# TODO: delete installation script
resource "oci_core_instance" "zookeeper_instance" {
  count                = var.zookeeper_instance_count
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  compartment_id       = var.compartment_id
  display_name         = "${var.zookeeper_instance_display_name}${count.index + 01}"
  shape                = var.zookeeper_instance_shape
  preserve_boot_volume = false
  freeform_tags        = {
    "Name" = "${var.zookeeper_instance_display_name}${count.index + 01}"
    "Application-Role" = "zookeeper"
  }
  metadata = { ssh_authorized_keys = file(var.kafka_zookeeper_ssh_public_key) }

  create_vnic_details {
    subnet_id        = var.kafka_zookeeper_subnet_id
    assign_public_ip = false
    display_name     = "${var.zookeeper_instance_display_name}${count.index + 01}"
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
    source      = "modules/kafka/config/services-controller/zookeeper"
    destination = "/tmp/zookeeper"
  }

  # copy zookeeper.properties (zookeeper config) to /tmp . In zookeeper.sh I'm moving it to the write location
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
    source      = "modules/kafka/config/app-config/zookeeper.properties"
    destination = "/tmp/zookeeper.properties"
  }

  # copy zookeeper.sh
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
    content     = data.template_file.zookeeper_setup.rendered
    destination = "~/zookeeper.sh"
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
      "chmod +x ~/zookeeper.sh",
      "~/zookeeper.sh ${count.index + 1} >> /home/opc/zookeeper_setup.log",
      "rm ~/zookeeper.sh -f"
    ]
  }
}



