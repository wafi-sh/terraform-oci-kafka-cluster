# terraform-oci-kafka-cluster
Terraform module to build Kafka cluster on Oracle cloud (OCI)

Terraform code to create:
1.	Bastion host 
2.	Zookeeper cluster with 3 nodes, each node in a separate availability domain
3.	Kafka cluster with 3 nodes, each node in a separate availability domain
4.	Run ZooNavigator, Kafka-manager, and Kafka-topics-ui as containers on the bastion host.

Assumptions:
-	Zookeeper and Kafka clusters has only 3 nodes each
-	The OCI region has at least 3 availability domains
