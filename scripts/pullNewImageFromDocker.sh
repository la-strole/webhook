#!/bin/bash

# Necessary variables: 
# 1. repoName
# 2. tagName
# Example: ./pullNewImageFromDocker.sh johndou/superrepo latest

log_file="webhook.log"

module_name="pullNewImageFromDocker.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"

# Pull the new image from docker
command_output=$(sudo docker pull $repoName:$tagName 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Image pulled from Docker successfully: $command_output"
else
    log "ERROR" "Failed to pull image from Docker: $command_output"
fi
