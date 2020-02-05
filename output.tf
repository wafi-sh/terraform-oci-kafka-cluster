# Output bastion public IP
output "bastion-ip" {
  value = module.kafka.bastion-ip
}

output "kafka-manager-url" {
  value = module.kafka.kafka-manager-url
}

output "zooNavigator-url" {
  value = module.kafka.zooNavigator-url
}

output "zooNavigator-connection-sting" {
  value = module.kafka.zooNavigator-connection-sting
}

output "kafka-bootstrap-servers" {
  value = module.kafka.kafka-bootstrap-servers
}

output "kafkastore_connection_url" {
  value = module.kafka.kafkastore_connection_url
}

output "kafka-ip" {
  value = module.kafka.kafka-ip
}

output "zookeeper-ip" {
  value = module.kafka.zookeeper-ip
}

#output "zookeeper-connect" {
#  value = module.kafka.zookeeper-connect
#}
output "fqdn" {
  value = module.kafka.fqdn
}

output "kafka-fqdn-list" {
  value = module.kafka.kafka-fqdn-list
}

output "kafka-topics-ui" {
  value = module.kafka.kafka-topics-ui
}
