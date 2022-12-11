# Elastic Stack Script

## Created for SYS255 Final Project - Molly Shapiro and Natalie Eckles

### Description

This is a set of four scripts for setting up a basic Elastic stack.

The stack contains Elasticsearch, Kibana, Winlogbeat with Sysmon, and Filebeat with Syslog. 

Elasticsearch can be set up and configured on the same server or different servers.

The Elasticsearch, Kibana, and Filebeat scripts are bash scripts.

The Winlogbeat script is a Powershell script.

### Details and Requirements

All scripts take user input for IP addresses, usernames and passwords. 

All scripts MUST be run as administrator or root, since they require access to directories that are restricted. 

After Elasticsearch and Kibana are installed, the user must go in and create two new users: winloguser and filebeatuser. These users must have custom-built roles:

The winlogbeatuser role requires manage_ilm and monitor roles on the cluster and the manage role on the winlogbeat-* indices

The filebeatuser role requires manage_ilm and monitor roles on the cluster and the manage role on the filebeat-* indices.

The winloguser user requires the winlogbeatuser role, the kibana_admin role, the superuser role, and the ingest_admin role.

The filebeatuser role requires the filebeatuser role, the kibana_admin role, the superuser role, and the ingest_admin role.

These users MUST be created before running the Winlogbeat and Filebeat scripts, since neither of these services can be started properly without access to Elastic.

