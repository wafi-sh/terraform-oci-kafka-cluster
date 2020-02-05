# Output bastion public IP
output "bastion-ip" {
  value = oci_core_instance.bastion_instance.public_ip
}

output "kafka-manager-url" {
  value = local.kafka_manager_url
}

output "zooNavigator-url" {
  value = local.zoonavigator_url
}

output "zooNavigator-connection-sting" {
  value = local.zoonavigator_connection_string
}

output "kafka-bootstrap-servers" {
  value = local.kafka_bootstrap_servers
}

output "kafkastore_connection_url" {
  value = local.kafkastore_connection_url
}

output "kafka-ip" {
  value = oci_core_instance.kafka_instance.*.private_ip
}

output "zookeeper-ip" {
  value = oci_core_instance.zookeeper_instance.*.private_ip
}

#output "zookeeper-connect" {
#  value = local.zookeeper_connect
#}
output "fqdn" {
  value = local.fqdn
}

output "kafka-fqdn-list" {
  value = local.kafka_fqdn_list
}

output "kafka-topics-ui" {
  value = local.kafka_topics_ui
}
