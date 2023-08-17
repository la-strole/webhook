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

sudo docker pull $repoName:$tagName 
command_output=$?

# Check if the command was successful or resulted in an error
if [ $command_output -eq 0 ]; then
    log "INFO" "Image $repoName:$tagName pulled from Docker successfully."
else
    log "ERROR" "Failed to pull image $repoName:$tagName from Docker."
fi
