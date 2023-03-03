#!/bin/bash

# Initializes variables for previously created Filebeat user creds

read -p "Enter the username for the Filebeat user you created in Kibana: " username
read -p "Enter the password for the Filebeat user you created in Kibana: " password

# This downloads and installs filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.15.1-amd64.deb
sudo dpkg -i filebeat-oss-7.15.1-amd64.deb

# This enables the system, elasticsearch, and kibana modules within Filebeat
sudo filebeat modules enable system
sudo filebeat modules enable elasticsearch
sudo filebeat modules enable kibana

cd /etc/filebeat

# This gathers the IPs of Elasticsearch and Kibana, to point the logs in the correct direction
read -p "What is the IP of the Elasticsearch server? " ipaddress
read -p "What is the IP of the Kibana server? " ipaddress1

# This makes changes to the filebeat.yml file to allow it to connect properly to the rest of the elastic stack
sed -i 's/enabled: false/enabled: true/I' filebeat.yml
sed -i 's/enabled: false/enabled: true/I' filebeat.yml
sed -i 's/#\(hosts: "localhost:9200"\)/\1/I' filebeat.yml
sed -i "s/hosts: \[\"localhost:9200\"\]/hosts: \[\"https:\/\/${ipaddress}:9200\"\]/I" filebeat.yml
sed -i 's/#\(protocol: "https"\)/\1/I' filebeat.yml
sed -i 's/#\(host: "localhost:5601"\)/\1/I' filebeat.yml
sed -i "s|host: \"localhost:5601\"|host: \"http:\/\/${ipaddress1}:5601\"|I" filebeat.yml
sed -i 's/#\(username:*\)/\1/I' filebeat.yml 
sed -i 's/username: "elastic"/username: \"$username\"/I' filebeat.yml
sed -i 's/#\(password:*\)/\1/I' filebeat.yml 
sed -i 's/password: "changeme"/password: \"$password\"/I' filebeat.yml
sed -i '187i\  ssl.verification_mode: none' filebeat.yml

# This enables and starts filebeat
sudo service filebeat enable
sudo service filebeat start

# This checks the settings and finalizes the setup
filebeat setup -e
