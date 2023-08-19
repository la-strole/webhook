#!/bin/bash

# Necessary variables: 
# 1. repoName (to be used as the image name).
# 2. tagName
# 3. options  - Parameters for the docker run command.
# 4. command - Commands for the docker run command.
# Example: ./runimage.sh johndou/superrepo latest myfavoritecontainer '-p 8080:80 -d --rm' 'ls -a'

log_file="./docker_webhook/webhook.log"

module_name="runImage.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"
containerName="$3"
options="$4"
command="$5"

log "DEBUG" "Starting the $module_name script"

# Run the new image
docker run $options --name $containerName $repoName:$tagName
command_output=$?
# Check if the command was successful or resulted in an error
if [ $command_output -eq 0 ]; then
    log "INFO" "Image $repoName:$tagName run in Docker successfully."
else
    log "ERROR" "Failed to run image $repoName:$tagName in Docker."
fi
