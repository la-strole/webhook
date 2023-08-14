#!/bin/bash

# Create a new user
sudo useradd -M -s /usr/sbin/nologin webhook

# Add the user to the Docker group
sudo usermod -aG docker webhook

# Define the content to be added to the sudoers file
content="webhook ALL=(ALL:ALL) NOPASSWD: /usr/bin/docker"

# Create a temporary file to store the content
temp_file=$(mktemp)

# Write the content to the temporary file
echo "$content" > "$temp_file"

# Use visudo to add the content to the sudoers file
sudo visudo -c -q -f "$temp_file" && sudo cat "$temp_file" >> /etc/sudoers.d/dockerCommand

# Clean up the temporary file
rm "$temp_file"

# Verify the configuration
sudo -u webhook docker ps