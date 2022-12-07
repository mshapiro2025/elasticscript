#!/bin/bash

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.15.1-amd64.deb
sudo dpkg -i filebeat-oss-7.15.1-amd64.deb

sudo filebeat modules enable system
sudo filebeat modules enable elasticsearch
sudo filebeat modules enable kibana
cd /etc/filebeat

echo What is the IP of the Elasticsearch server?
read ipaddress
echo What is the IP of the Kibana server?
red ipaddress1

sed -i "s/hosts: \[\"localhost:9200\"\]/hosts: \[\"https:\/\/${ipaddress}:9200\'\]/I" filebeat.yml
sed -i 's/#\(protocol: "https"\)/\1/I' filebeat.yml
sed -i
