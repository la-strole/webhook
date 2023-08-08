#!/bin/bash
#Create new user 
sudo useradd -M -s /usr/sbin/nologin webhook
# Add user to group Docker
sudo usermod -aG docker webhook
# Add permissions to run docker as root to user docker 
sudo visudo -f /etc/sudoers.d/dockerCommand
#4. there add: 
# webhook ALL=(ALL:ALL) NOPASSWD: /usr/bin/docker

# check configuration
sudo -u webhook docker ps
