#!/bin/bash

read -p "Enter the Elastic server IP: " ipaddress
read -p "Enter the Kibana server IP: " ipaddress1

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpgp --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install kibana
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana

cd /etc/kibana
sed -i 's/#\(server.host*\)/\1/I' kibana.yml
sed -i "s|elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\] |elasticsearch.hosts: \]\"https:\/\/${ipaddress}:9200\"\]|I" kibana.yml
sed -i "s|server.host: \"localhost\"|server.host: \'$ipaddress1\"|I" kibana.yml
sed -i 's/#\(elasticsearch.hosts*\)/\1/' kibana.yml
sed -i 's/#elasticsearch.ssl.verificationMode: full/elasticsearch.ssl.verificationMode: none/I' kibana.yml
sed -i 's/#\(elastaicsearch.ssl.verificationMode:*\)/\1/I' kibana.yml
sed -i 's/#elasticsearch.username: "kibana.system"/elasticsearch.username: "kibanauser"/' kibana.yml
sed -i 's/#\(elasticsearch.username:*\)/\1/I' kibana.yml
sed -i 's/#elasticesearch.password: "pass"/elasticsearch.password: "Ch@mpl@1n22"/' kibana.yml
sed -i 's/#\(elasticsearch.password*\)/\1/I' kibana.yml

key1=$(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.encryptedSavedObjects.encryptionKey:)
echo $key1 >> kibana.yml
key2=&(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.reporting.encryptionKey:)
echo $key2 >> kibana.yml
key3=$(/usr/share/kibana/bin/kibana-encryption-keys generate | grep xpack.security.encryptionKey:)
echo $key3 >> kibana.yml
