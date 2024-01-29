#!/bin/bash

INI_FILE="../ansible/ip_inventory.ini"

deployment_server_ip=$(terraform output deployment_server_ip | tr -d '"')
gitlab_server_ip=$(terraform output gitlab_server_ip | tr -d '"')
jenkins_agent_ip=$(terraform output jenkins_agent_ip | tr -d '"')
jenkins_master_ip=$(terraform output jenkins_master_ip | tr -d '"')

sed -i "/\[deployment_server\]/,/^$/s/^[0-9.]\+/$deployment_server_ip/" "$INI_FILE"
sed -i "/\[gitlab_server\]/,/^$/s/^[0-9.]\+/$gitlab_server_ip/" "$INI_FILE"
sed -i "/\[jenkins_agent\]/,/^$/s/^[0-9.]\+/$jenkins_agent_ip/" "$INI_FILE"
sed -i "/\[jenkins_master\]/,/^$/s/^[0-9.]\+/$jenkins_master_ip/" "$INI_FILE"

echo "yay!"

