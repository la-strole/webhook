#!/bin/bash

# RUN WITH SUDO!

# Copy service file to systemd folder
sudo cp gunicorn.service /etc/systemd/system/

# Copy socket conf to systemd folder
sudo cp gunicorn.socket /etc/systemd/system/

# enable and start the socket (it will autostart at boot too):
sudo systemctl enable --now gunicorn.socket
