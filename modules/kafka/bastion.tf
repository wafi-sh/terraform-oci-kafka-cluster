# TODO: create separate key for bastion other than private instances (kafka/zk)
resource "oci_core_instance" "bastion_instance" {

  availability_domain = var.bastion_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.bastion_instance_shape
  display_name        = var.bastion_display_name
  freeform_tags       = {"Name" = var.bastion_display_name}
  metadata = {
    ssh_authorized_keys = file(var.bastion_ssh_public_key)
    #user_data           = base64encode(file(var.bastion-cloud-init))
  }
  preserve_boot_volume = false
  create_vnic_details {
    subnet_id        = var.bastion_subnet_id
    assign_public_ip = true
    display_name     = var.bastion_display_name
    nsg_ids          = var.bastion_nsg_ids
  }
  source_details {
    source_id   = var.image_id
    source_type = "image"
  }
}

# run zoonavigator, kafka-manager, and kafka-topics-ui containers (with supporting containers) on bastion host
resource "null_resource" "ui-tools" {
  depends_on = [oci_core_instance.bastion_instance,oci_core_instance.kafka_instance,oci_core_instance.zookeeper_instance]
  provisioner "remote-exec" {
    connection {
      host        = oci_core_instance.bastion_instance.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.bastion_user
      private_key = file(var.bastion_ssh_private_key)
    }
    inline = [
      "sudo yum update -y",
      "sudo yum install nc -y",
      "sudo systemctl stop firewalld",
      "sudo systemctl disable firewalld",

      "sudo yum install docker-engine -y",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo docker run -d --network host -e HTTP_PORT=9001 --name zoonavigator --restart unless-stopped elkozmon/zoonavigator:latest",
      "sudo docker run -d --network host -e ZOOKEEPER_HOSTS='${local.zoonavigator_connection_string}' -e APPLICATION_SECRET='123213' --name kafka-manager --restart always qnib/plain-kafka-manager:latest",
      "sudo docker run -d --network host -e SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL='${local.kafkastore_connection_url}' -e SCHEMA_REGISTRY_LISTENERS='http://0.0.0.0:8081' -e SCHEMA_REGISTRY_HOST_NAME='${oci_core_instance.bastion_instance.public_ip}' --name confluent-schema-registry --restart always confluentinc/cp-schema-registry:latest",
      "sudo docker run -d --network host -e KAFKA_REST_BOOTSTRAP_SERVERS='${local.kafka_bootstrap_servers}' -e KAFKA_REST_ZOOKEEPER_CONNECT='${local.kafkastore_connection_url}' -e KAFKA_REST_LISTENERS='http://0.0.0.0:8082/' -e KAFKA_REST_SCHEMA_REGISTRY_URL='http://localhost:8081/' -e KAFKA_REST_HOST_NAME='${oci_core_instance.bastion_instance.public_ip}' --name confluent-rest-proxy --restart always confluentinc/cp-kafka-rest:latest",
      "sudo docker run -d --network host -e KAFKA_REST_PROXY_URL='http://localhost:8082' -e PROXY='TRUE' --name kafka-topics-ui --restart always landoop/kafka-topics-ui:latest"
    ]
  }
}