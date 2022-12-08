# Initialize the variables for IP addresses and Elastic authentication credentials

$kibanaip = Read-Host -Prompt "Enter your Kibana server IP"
$elasticip = Read-Host -Prompt "Enter your Elastic server IP"
$elasticuser = Read-Host -Prompt "Enter your Elastic Winlogbeat user username"
$elasticpass = Read-Host -Prompt "Enter your Elastic Winlogbeat password"

$elastichost = 'https://' + $elasticip + ':9200'
$kibanahost = 'http://' + $kibanaip + ':5601'

Invoke-WebRequest -UseBasicParsing https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.5.2-iwndows-x86_64.zip -OutFile "winlogbeat-8.5.2-windows-x86_64.zip"
Start-Sleep -s 300
Expand-Archive winlogbeat-8.5.2-windows-x86_64.zip "C:/Program Files"
cd "C:/Program Files"
Rename-Item winlogbeat-8.5.2-windows-x86_64.zip "C:/Program Files"
cd Winlogbeat
Powershell.exe -ExecutionPolicy Unrestricted -File ./install-service-winlogbeat.ps1
Start-Sleep -s 60

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
(Get-Content winlogbeat.yml) -replace "hosts: \[`"localhost:9200`"\]", "hosts: [`"$elastichost`"]" | Add-Content winlogbeat1.yml
Remove-Item winlogbeat.yml
Rename-Item winlogbeat1.yml winlogbeat.yml

Invoke-WebRequest -UseBasicParsing https://download.sysinternals.com/files/Sysmon.zip -OutFile "Sysmon.zip"
Start-Sleep -s 300
Expand-Archive Sysmon.zip "C:/Program Files"
cd "C:/Program Files"
./sysmon --accepteula
Start-Sleep -s 60

cd "C:/Program Files/Winlogbeat"
winlogbeat setup -e


