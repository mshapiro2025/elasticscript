#!/bin/bash

echo "What is your node name?"
read $1
echo "What is your Elastic server IP address?"
read $2

apt-get update

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

apt-get update && apt-get install elasticsearch

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

cd /etc/elasticsearch
sed -i "s/#node.name: node-1/node.name $1/I" elasticsearch.yml
sed -i "s/#network.host: 192.168.0.1/network.host $2/I" elasticsearch.yml

cd ~
/usr/share/elasticsearch/bin/elasticsearch-users useradd admin -p password
/user/share/elasticsearch/bin/elasticsearch-users roles admin -a superuser

/usr/share/elasticsearch/bin/elasticsearch-users useradd kibanauser -p Ch@mpl@1n22
/usr/share/elasticsearch/bin/elasticsearch-users roles kibanauser -a superuser
/usr/share/elasticsearch/bin/elasticsearch-users roles kibanauser -a kibana_system

echo "Your username is admin and your password is password. Please change these ASAP!"
echo "Your Kibana system username is kibanauser and your password is Ch@mpl@1n22."
