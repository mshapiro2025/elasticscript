# Initialize the variables for IP addresses and Elastic authentication credentials

$kibanaip = Read-Host -Prompt "Enter your Kibana server IP"
$elasticip = Read-Host -Prompt "Enter your Elastic server IP"
$elasticuser = Read-Host -Prompt "Enter your Elastic Winlogbeat user username"
$elasticpass = Read-Host -Prompt "Enter your Elastic Winlogbeat password"

$elastichost = 'https://' + $elasticip + ':9200'
$kibanahost = 'http://' + $kibanaip + ':5601'

cd "C:/Program Files/Winlogbeat"

# Replace the default Kibana IP address with the user-inputted IP
(Get-Content winlogbeat.yml) -replace "#host: `"localhost:5601`"", "host:`"$kibanahost`"" | Add-Content winlogbeat1.yml
Remove-Item winlogbeat.yml
Rename-Item winlogbeat1.yml winlogbeat.yml
# Replace the default Elastic username with the user-inputted name
(Get-Content winlogbeat.yml) -replace "#username: `"elastic`"", "username: `"$elasticuser`"" | Add-Content winlogbeat1.yml
Remove-Item winlogbeat.yml
Rename-Item winlogbeat1.yml winlogbeat.yml
# Replace the default Elastic password placeholder with the user-inputted password
(Get-Content winlogbeat.yml) -replace "#password: `"changeme`"", "password: `"$elasticpass`"" | Add-Content winlogbeat1.yml
Remove-Item winlogbeat.yml
Rename-Item winlogbeat1.yml winlogbeat.yml
# Replace the default Elasticsearch IP address with the user-inputted IP
(Get-Content winlogbeat.yml) -replace "hosts: \[`"localhost:9200`"\]", "hosts: [`"$elastichost`"]"
