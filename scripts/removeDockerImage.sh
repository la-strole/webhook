#!/bin/bash

# Necessary variables: 
# 1. Repository name (to be used as the image name).
# 2. tagName
# Example: ./removeDockerImage.sh johndou/superrepo 1.2.1

log_file="webhook.log"

module_name="removeOldDockerImage.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"

log "DEBUG" "Starting the $module_name script"

# Remove the old docker image
command_output=$(sudo docker image rm $repoName:$tagName 2> >(tee /dev/stderr))
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Old image removed successfully: $command_output"
else
    log "ERROR" "Failed to remove old image: $command_output"
fi