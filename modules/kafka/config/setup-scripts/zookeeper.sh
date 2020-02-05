#!/bin/bash
set -e -x

function installZookeeper() {
  #echo from inside sh script indise installZookeeper function: "$1" >> /tmp/check1
  # stop and disable firewall
  sudo systemctl stop firewalld && sudo systemctl disable firewalld
  # create Zookeeper data directory
  sudo mkdir /apps
  sudo mkdir /apps/zookeeper

  cd /tmp
  # download kafka
  sudo wget https://www-eu.apache.org/dist/kafka/2.4.0/kafka_2.13-2.4.0.tgz
  # extract downloaded file, remove tgz file, move to /opt and rename the extracted folder
  sudo tar -zxvf kafka_2.13-2.4.0.tgz
  sudo rm kafka_2.13-2.4.0.tgz -f
  sudo mv kafka_2.13-2.4.0 /opt/kafka
  cd /opt/kafka
  # remove default zookeeper configuration that comes with Kafka package
  sudo rm /opt/kafka/config/zookeeper.properties
  # move zookeeper new confige to the right location
  sudo mv /tmp/zookeeper.properties /opt/kafka/config/zookeeper.properties
  # add zookeeper servers to the configuration
  for i in `seq ${number_of_zookeeper}`
    do
      server_fqdn=${display_name}$i.pri.iadcoit.oraclevcn.com
      echo "server.$i=$server_fqdn:${zookeeper_internal_port}:${zookeeper_poll_port}" >> /opt/kafka/config/zookeeper.properties
  done

  # add zookeeper node id to myid file.
  echo "$1" | sudo tee -a /apps/zookeeper/myid
  # run zookeeper as daemon
  # to make sure zokkeper does started as daemon run
  # bin/zookeeper-shell.sh localhost:2181
  # then
  # ls /
  # you should get [zookeeper]
  sudo bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
  # move and change zookeeper service bootstrab to executable and owner to root
  sudo mv /tmp/zookeeper /etc/init.d/zookeeper
  sudo chmod +x /etc/init.d/zookeeper
  sudo chown root:root /etc/init.d/zookeeper
  # add zookeeper to start automatically after reboot
  sudo chkconfig zookeeper on
}

echo "==================================================================================="
echo "Begin Zookeeper setup"

# Update current packages and install nc
sudo yum update -y
sudo yum install nc -y

# stop firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Install java 8 (must be 8)
sudo yum -y install nc java-1.8.0-openjdk

# Disable RAM Swap and make it persistent after restart
sudo sysctl vm.swappiness=0
echo 'vm.swappiness=0' | sudo tee --append /etc/sysctl.conf

#Install Zookeeper
installZookeeper "$1"

echo "End Zookeeper setup"
echo "==================================================================================="
