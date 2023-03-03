#!/bin/bash

read -p "What is your node name? " node
read -p "What is your Elastic server IP address? " ipaddress
read -p "What do you want your Elastic superuser username to be? " esuser
read -p "What do you want your Elastic superuser password to be? " espass
read -p "What do you want your Kibana username to be? " kbuser
read -p "What do you want your Kibana password to be? " kbpass

apt-get update

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

apt-get update && apt-get install elasticsearch

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

cd /etc/elasticsearch
sed -i "s/#node.name: node-1/node.name: $node/I" elasticsearch.yml
sed -i "s/#network.host: 192.168.0.1/network.host: $ipaddress/I" elasticsearch.yml

cd ~
/usr/share/elasticsearch/bin/elasticsearch-users useradd $esuser -p $espass
/usr/share/elasticsearch/bin/elasticsearch-users roles admin -a superuser

/usr/share/elasticsearch/bin/elasticsearch-users useradd $kbuser -p $kbpass
/usr/share/elasticsearch/bin/elasticsearch-users roles kibanauser -a superuser
/usr/share/elasticsearch/bin/elasticsearch-users roles kibanauser -a kibana_system

systemctl restart elasticsearch

echo "Your username is $esadmin and your password is $espass. Please change these ASAP!"
echo "Your Kibana system username is $kbuser and your password is $kbpass."
