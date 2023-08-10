#!/bin/bash
log_file="webhook.log"

module_name="downloadImage.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"
containerName="$3"

log "DEBUG" "Starting the $module_name script"

# Stop the running docker container
command_output=$(sudo docker stop $containerName 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Container stopped successfully: $command_output"
else
    log "ERROR" "Failed to stop container: $command_output"
fi

# Remove the old docker image
# Wait for 7 seconds
sleep 7
command_output=$(sudo docker image rm $repoName:$tagName 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Old image removed successfully: $command_output"
else
    log "ERROR" "Failed to remove old image: $command_output"
fi

# Pull the new image from docker
sleep 5
command_output=$(sudo docker pull $repoName:$tagName 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Image pulled from Docker successfully: $command_output"
else
    log "ERROR" "Failed to pull image from Docker: $command_output"
fi

