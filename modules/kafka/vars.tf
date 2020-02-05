# General vars
variable "compartment_id" {}
variable "image_id" {}
variable "kafka_zookeeper_ssh_public_key" {}
variable "kafka_zookeeper_ssh_private_key" {}
variable "kafka_zookeeper_subnet_id" {}
variable "kafka_zookeeper_nsg_ids" {}
variable "kafka_zookeeper_user" {}
# Bastion vars
variable "bastion_availability_domain" {}
variable "bastion_instance_shape" {}
variable "bastion_display_name" {}
variable "bastion_ssh_public_key" {}
variable "bastion_ssh_private_key" {}
variable "bastion_subnet_id" {}
variable "bastion_nsg_ids" {}
variable "bastion_user" {}
# Zookeeper vars
variable "zookeeper_instance_count" {default = 3}
variable "zookeeper_instance_display_name" {description ="Zookeeper instance name prefix. 01,02,..n will be added automatically" }
variable "zookeeper_instance_shape" {}
variable "zookeeper_client_port" { description = "Zookeeper client port" }
variable "zookeeper_internal_port" { description = "Zookeeper internal port" }
variable "zookeeper_poll_port" { description = "Zookeeper poll port" }
# Kafka vars
variable "kafka_instance_count" {default = 3}
variable "kafka_instance_display_name" {description ="Kafka instance name prefix. 01,02,..n will be added automatically" }
variable "kafka_instance_shape" {}
variable "kafka_client_port" { description = "Kafka client port" }