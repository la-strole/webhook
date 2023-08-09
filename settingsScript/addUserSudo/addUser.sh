#!/bin/bash
# Create a new user
sudo useradd -M -s /usr/sbin/nologin webhook
# Add the user to the Docker group
sudo usermod -aG docker webhook
# Grant permission to allow the user 'webhook' to execute Docker as root
sudo visudo -f /etc/sudoers.d/dockerCommand
# In this file, add the following line:
# webhook ALL=(ALL:ALL) NOPASSWD: /usr/bin/docker

# Verify the configuration
sudo -u webhook docker ps
