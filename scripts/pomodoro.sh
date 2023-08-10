#!/bin/bash
log_file="webhook.log"

module_name="pomodoro.sh"

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

# Run the new image
sleep 5
command_output=$(sudo docker run -p 8123:80 -d --rm --name $containerName $repoName:$tagName 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Image run in Docker successfully: $command_output"
else
    log "ERROR" "Failed to run image in Docker: $command_output"
fi
