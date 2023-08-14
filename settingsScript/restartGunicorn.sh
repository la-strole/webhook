#!/bin/bash

# Perform this step after making changes in the *py files
sudo systemctl restart gunicorn.service
