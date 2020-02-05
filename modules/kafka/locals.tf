locals {
#  zookeeper_connect_tmp = join(":${var.zookeeper_client_port},", oci_core_instance.zookeeper_instance.*.hostname_label)
#  zookeeper_connect     = join(":", [local.zookeeper_connect_tmp, "${var.zookeeper_client_port}/kafka"])
  zookeeper_fqdn_list   = formatlist("%s${local.fqdn}", oci_core_instance.zookeeper_instance.*.hostname_label)

  # for output purposes only
  zoonavigator_connection_string_tmp = join(":${var.zookeeper_client_port},", oci_core_instance.zookeeper_instance.*.private_ip)
  zoonavigator_connection_string     = join("", [local.zoonavigator_connection_string_tmp, ":${var.zookeeper_client_port}"])

  zoonavigator_url_tmp = join("", [oci_core_instance.bastion_instance.public_ip, ":9001"])
  zoonavigator_url     = join("", ["http://", local.zoonavigator_url_tmp])

  kafka_manager_url_tmp = join("", [oci_core_instance.bastion_instance.public_ip, ":9000"])
  kafka_manager_url     = join("", ["http://", local.kafka_manager_url_tmp])

  kafka_fqdn_list = formatlist("%s${local.fqdn}", oci_core_instance.kafka_instance.*.hostname_label)

  kafkastore_connection_url_tmp = join(":${var.zookeeper_client_port},", local.zookeeper_fqdn_list)
  kafkastore_connection_url     = join("", [local.kafkastore_connection_url_tmp, ":${var.zookeeper_client_port}/kafka"])

  kafka_bootstrap_servers_tmp = join(":${var.kafka_client_port},", local.kafka_fqdn_list)
  kafka_bootstrap_servers     = join("", [local.kafka_bootstrap_servers_tmp, ":${var.kafka_client_port}"])

  fqdn                = join("", [".", data.oci_core_subnet.private_subnet.subnet_domain_name])
  kafka_topics_ui_tmp = join("", [oci_core_instance.bastion_instance.public_ip, ":8000"])
  kafka_topics_ui     = join("", ["http://", local.kafka_topics_ui_tmp])
}