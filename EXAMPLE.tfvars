# Provider vars
tenancy_ocid              = "ocid1.tenancy.oc1..aaaaaaaaiso7crckuydansxjriwasdfasdfasfasdfasd"
user_ocid                 = "ocid1.user.oc1..aaaaaaaapxfqbtasdfasdfasdfasdfasf"
fingerprint               = "12:44:3c:f4:62:ab:30:34:cb:9d:d5:8d:6a:42:22"
provider_private_key_path = "C:\\Users\\me\\Documents\\oci_api_key.pem"
region                    = "us-ashburn-1"

# General vars
compartment_id                  = "ocid1.compartment.oc1..aaaaaaaampet6i2asdfasdfasdfasf"
image_id                        = "ocid1.image.oc1.iad.aaaaaaaaxrcvnpfxfsyzv3ytuu6swalnbmocneej6yj4nr4vbcoufgmfpwqq"
kafka_zookeeper_ssh_public_key  = "key\\instences-keys\\public.pub"
kafka_zookeeper_ssh_private_key = "key\\instences-keys\\private.pem"
kafka_zookeeper_subnet_id       = "ocid1.subnet.oc1.iad.aaaaaaaadndaoy6uovoknul4guk3sadfsadfasdfv3q"
kafka_zookeeper_nsg_ids         = ["ocid1.networksecuritygroup.oc1.iad.aaaaaaaa6lcq7glrclfasdfasdfsadfk25oa"]
kafka_zookeeper_user            = "opc"

# Bastion vars
bastion_availability_domain = "eEri:US-ASHBURN-AD-1"
bastion_instance_shape      = "VM.Standard2.1"
bastion_display_name        = "BASTION"
bastion_ssh_public_key      = "key\\bastion\\public.pub"
bastion_ssh_private_key     = "key\\bastion\\private.pem"
bastion_subnet_id           = "ocid1.subnet.oc1.iad.aaaaaaaaxwei7rzmwiiaadsfasdfasdfasdffra"
bastion_nsg_ids             = ["ocid1.networksecuritygroup.oc1.iad.aaaaaaaasdfsadfsdfasdfasdfasdfas6k25oa", "ocid1.networksecuritygroup.oc1.iad.aaaaaaaaovasdfasdfasdfasdfm4k6bqn37fm5dsafl33uq"]
bastion_user                = "opc"

# Zookeeper vars
zookeeper_instance_display_name = "ZOOKEEPER"
zookeeper_instance_shape        = "VM.Standard2.1"
zookeeper_client_port           = "2181"
zookeeper_internal_port         = "2888"
zookeeper_poll_port             = "3888"
# Kafka vars

kafka_instance_display_name = "KAFKA"
kafka_instance_shape        = "VM.Standard2.1"
kafka_client_port           = "9092"
