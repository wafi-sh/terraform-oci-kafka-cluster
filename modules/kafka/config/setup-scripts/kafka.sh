#!/bin/bash
set -e -x

function installkafka() {
  # create kafka directory full path
  sudo mkdir -p /apps/kafka
  # update kafka config (broker.id)
  sed -i "s/broker.id=/broker.id=$1/g" /tmp/server.properties
  # update kafka config (advertised.listeners). I'm using # instead of / in sed as the replacment text already has // in it.
  sed -i "s#advertised.listeners=#advertised.listeners=PLAINTEXT://${kafka_instance_display_name}$1${fqdn}:${kafka_client_port}#g" /tmp/server.properties

  # downlaod, untar, and place kafka in the right location
  cd /tmp/
  wget https://www-us.apache.org/dist/kafka/2.4.0/kafka_2.13-2.4.0.tgz
  tar -xzf kafka_2.13-2.4.0.tgz
  sudo mv /tmp/kafka_2.13-2.4.0/ /opt/kafka/

  # move kafka config to the right location
  sudo mv /tmp/server.properties /opt/kafka/config/server.properties
  # start kafka as daemon
  sudo /opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties
  # move kafka service boot script to init.d
  chmod +x /tmp/kafka
  sudo chown root:root /tmp/kafka
  sudo mv /tmp/kafka /etc/init.d/kafka
  # add kafka to start automatically after reboot
  sudo chkconfig kafka on
}

echo "==================================================================================="
echo "Begin Kafka setup"

sudo yum update -y
sudo yum install nc -y

# disable and stop firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Install java 8 (must be 8)
sudo yum -y install nc java-1.8.0-openjdk

#Install Kafka
installkafka $1

# Add file limits configs - allow to open 100,000 file descriptors. Then reboot to apply changes
echo "* hard nofile 100000
* soft nofile 100000" | sudo tee --append /etc/security/limits.conf
sudo shutdown -r 1

echo "End Kafka setup"
echo "==================================================================================="
