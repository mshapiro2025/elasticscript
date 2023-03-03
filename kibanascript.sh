#!/bin/bash

# This gathers user input for both the Kibana and Elastic IPs, in case they're run on seperate servers
read -p "Enter the Elastic server IP: " ipaddress
read -p "Enter the Kibana server IP: " ipaddress1
read -p "Enter the Kibana username you created earlier: " username
read -p "Enter the Kibana password you created earlier: " password

apt-get update

# This gets the GPG key again. Although it was obtained in the Elastic script, it is here again in case of they're run on seperate servers
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# This installs and enables kibana
sudo apt-get update && sudo apt-get install kibana
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana

# These make changes to the kibana.yml file, configuring the kibana server with a user, IPs for kibana and elastic, uncommenting necessary lines, and setting the ssl
# verification mode to none
cd /etc/kibana
sed -i 's/#\(server.host*\)/\1/I' kibana.yml
sed -i "s|elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\]|elasticsearch.hosts: \[\"https:\/\/${ipaddress}:9200\"\]|I" kibana.yml
sed -i "s|server.host: \"localhost\"|server.host: \"$ipaddress1\"|I" kibana.yml
sed -i 's/#\(elasticsearch.hosts*\)/\1/' kibana.yml
sed -i 's/#elasticsearch.ssl.verificationMode: full/elasticsearch.ssl.verificationMode: none/I' kibana.yml
sed -i 's/#\(elasticsearch.ssl.verificationMode:*\)/\1/I' kibana.yml
sed -i 's/#elasticsearch.username: "kibana.system"/elasticsearch.username: \"$username\"/' kibana.yml
sed -i 's/#\(elasticsearch.username:*\)/\1/I' kibana.yml
sed -i 's/#elasticsearch.password: "pass"/elasticsearch.password: \"$password\"/' kibana.yml
sed -i 's/#\(elasticsearch.password*\)/\1/I' kibana.yml

# This gathers the xpack encryption keys and writes them to the kibana.yml file
key1=$(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.encryptedSavedObjects.encryptionKey:)
echo $key1 >> kibana.yml
key2=$(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.reporting.encryptionKey:)
echo $key2 >> kibana.yml
key3=$(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.security.encryptionKey:)
echo $key3 >> kibana.yml
