#!/bin/bash

# Necessary variables: 
# 1. container name.
# Example: ./removeDockerContainer.sh continerName

log_file="./docker_webhook/webhook.log"

module_name="removeDockerContainer.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

containerName="$1"

log "DEBUG" "Starting the $module_name script"

# Remove the docker container

docker rm $containerName
command_output=$?
# Check if the command was successful or resulted in an error
if [ $command_output -eq 0 ]; then
    log "INFO" "Container $containerName removed successfully."
else
    log "ERROR" "Failed to remove container $containerName."
fi
