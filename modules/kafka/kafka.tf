# TODO: delete installation script
resource "oci_core_instance" "kafka_instance" {
  count                = var.kafka_instance_count
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  compartment_id       = var.compartment_id
  display_name         = "${var.kafka_instance_display_name}${count.index + 01}"
  shape                = var.kafka_instance_shape
  preserve_boot_volume = false
  freeform_tags        = {
    "Name" = "${var.kafka_instance_display_name}${count.index + 01}"
    "Application-Role" = "kafka"
  }
  metadata = {
    ssh_authorized_keys = file(var.kafka_zookeeper_ssh_public_key)
  }

  create_vnic_details {
    subnet_id        = var.kafka_zookeeper_subnet_id
    assign_public_ip = false
    display_name     = "${var.kafka_instance_display_name}${count.index + 01}"
    nsg_ids          = var.kafka_zookeeper_nsg_ids
  }
  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  # copy zookeeper service bootstrap to /tmp . In zookeeper.sh I'm moving it to /etc/init.d/ and changing permissions and owner to root
  # OPC user has no permission to write to /etc/init.d
  # can't use root to ssh
  provisioner "file" {
    connection {
      host                = self.private_ip
      agent               = false
      timeout             = "5m"
      user                = var.kafka_zookeeper_user
      private_key         = file(var.kafka_zookeeper_ssh_private_key)
      bastion_host        = oci_core_instance.bastion_instance.public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = file(var.bastion_ssh_private_key)
    }
    source      = "modules/kafka/config/services-controller/kafka"
    destination = "/tmp/kafka"
  }

  provisioner "file" {
    connection {
      host                = self.private_ip
      agent               = false
      timeout             = "5m"
      user                = var.kafka_zookeeper_user
      private_key         = file(var.kafka_zookeeper_ssh_private_key)
      bastion_host        = oci_core_instance.bastion_instance.public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = file(var.bastion_ssh_private_key)
    }
    content     = data.template_file.kafka_config.rendered
    destination = "/tmp/server.properties"
  }
  provisioner "file" {
    connection {
      host                = self.private_ip
      agent               = false
      timeout             = "5m"
      user                = var.kafka_zookeeper_user
      private_key         = file(var.kafka_zookeeper_ssh_private_key)
      bastion_host        = oci_core_instance.bastion_instance.public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = file(var.bastion_ssh_private_key)
    }
    content     = data.template_file.kafka_setup.rendered
    destination = "~/kafka_setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      host                = self.private_ip
      agent               = false
      timeout             = "5m"
      user                = var.kafka_zookeeper_user
      private_key         = file(var.kafka_zookeeper_ssh_private_key)
      bastion_host        = oci_core_instance.bastion_instance.public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = file(var.bastion_ssh_private_key)
    }

    inline = [
      "chmod +x ~/kafka_setup.sh",
      "~/kafka_setup.sh ${count.index + 1} >> /home/opc/kafka_setup.log",
      "rm ~/kafka_setup.sh -f"
    ]
  }
}
