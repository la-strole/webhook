#!/bin/bash

# Necessary variables: 
# 1. container name.
# Example: ./stopDockerContainer.sh continerName

log_file="webhook.log"

module_name="stopDockerContainer.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

containerName="$1"

log "DEBUG" "Starting the $module_name script"

# Stop the running docker container
command_output=$(sudo docker stop $containerName 2> >(tee /dev/stderr))
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "INFO" "Container stopped successfully: $command_output"
else
    log "ERROR" "Failed to stop container: $command_output"
fi

# Remove the container
command_output=$(sudo docker rm $containerName 2> >(tee /dev/stderr))
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "INFO" "Container removed successfully: $command_output"
else
    log "ERROR" "Failed to remove container: $command_output"
fi