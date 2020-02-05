data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_core_subnet" "private_subnet" {
  subnet_id = var.kafka_zookeeper_subnet_id
}

data "template_file" "zookeeper_setup" {
  template = file("modules/kafka/config/setup-scripts/zookeeper.sh")
  vars = {
    zookeeper_client_port       = var.zookeeper_client_port
    zookeeper_internal_port     = var.zookeeper_internal_port
    zookeeper_poll_port         = var.zookeeper_poll_port
    kafka_client_port           = var.kafka_client_port
    number_of_zookeeper         = var.zookeeper_instance_count
    display_name                = var.zookeeper_instance_display_name
  }
}

data "template_file" "kafka_setup" {
  template = file("modules/kafka/config/setup-scripts/kafka.sh")
  vars = {
    zookeeper_client_port       = var.zookeeper_client_port
    zookeeper_internal_port     = var.zookeeper_internal_port
    zookeeper_poll_port         = var.zookeeper_poll_port
    kafka_client_port           = var.kafka_client_port
    number_of_kafka             = var.kafka_instance_count
    kafka_instance_display_name = var.kafka_instance_display_name
    fqdn                        = local.fqdn
  }
}

data "template_file" "kafka_config" {
  template = file("modules/kafka/config/app-config/server.properties")
  vars = {
    zookeeper_connect = local.kafkastore_connection_url
  }
}

