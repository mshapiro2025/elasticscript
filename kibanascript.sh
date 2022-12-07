#!/bin/bash

read -p "Enter the Elastic server IP" ipaddress
read -p "Enter the Kibana server IP" ipaddress

sudo apt-get update && sudo apt-get install kibana
