#!/bin/bash

# Necessary variables: 
# 1. Repository name (to be used as the image name).
# 2. tagName
# Example: ./removeDockerImage.sh johndou/superrepo 1.2.1

log_file="./docker_webhook/webhook.log"

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
docker image rm $repoName:$tagName
command_output=$?
# Check if the command was successful or resulted in an error
if [ $command_output -eq 0 ]; then
    log "INFO" "Old image $repoName:$tagName removed successfully."
else
    log "ERROR" "Failed to remove old image $repoName:$tagName."
fi