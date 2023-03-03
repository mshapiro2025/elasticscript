# This script will install a standalone Elastic Agent on a Windows endpoint using Powershell. In order for the Agent to function properly,
# you must configure an agent policy in Kibana under Stack Management/Fleets and copy the configuration file. 
# This script must be run in an administrative Powershell prompt.

# Install Elastic Agent for Windows
Invoke-WebRequest https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.6.2-windows-x86_64.zip -OutFile elastic-agent.zip
Expand-Archive elastic-agent.zip "C:/Program Files"
cd "C:/Program Files/elastic-agent"
.\elastic-agent.exe install

# Now, copy the configuration from Kibana to elastic-agent.yml

# Enabling and starting Elastic Agent
Get-Service "Elastic Agent"
Set-Service -Name "Elastic Agent" -StartupType Automatic
Start-Service "Elastic Agent"

# Logs for Elastic Agent will start appearing in the logs-* and metrics-* indices. 
