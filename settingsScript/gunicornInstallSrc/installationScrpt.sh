#!/bin/bash

# EXECUTE WITH SUDO!

# Copy the service file to the systemd directory
sudo cp gunicorn.service /etc/systemd/system/

# Copy the socket configuration to the systemd directory
sudo cp gunicorn.socket /etc/systemd/system/

# Enable and start the socket (it will also automatically launch on boot).
sudo systemctl enable --now gunicorn.socket
