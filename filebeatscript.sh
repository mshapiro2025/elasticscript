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
read ipaddress1

sed -i 's/enabled: false/enabled: true/I' filebeat.yml
sed -i 's/enabled: false/enabled: true/I' filebeat.yml
sed -i "s/hosts: \[\"localhost:9200\"\]/hosts: \[\"https:\/\/${ipaddress}:9200\'\]/I" filebeat.yml
sed -i 's/#\(protocol: "https"\)/\1/I' filebeat.yml
sed -i "s|host: \"localhost:5601\"|host: \"${ipaddress1}:5601\"|I" filebeat.yml
sed -i 's/username: "elastic"/username: "filebeatuser"/I' filebeat.yml
sed -i 's/password: "changeme"/password: "password"/I' filebeat.yml
sed -i 's/#\(password:*\)/\1/I' filebeat.yml 
sed -i '187i\  ssl.veritifaction_mode: none' filebeat.yml

sudo service filebeat enable
sudo service filebeat start

filebeat setup -e
