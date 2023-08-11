#!/bin/bash

log_file="webhook.log"

module_name="pomodoroWorkflow.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"
containerName="$3"

# Stop existed pomodoro container
./stopDockerContainer.sh $repoName $tagName $containerName 

# Remove old Docker image
./removeOldDockerImage.sh $repoName $tagName $containerName

# Pull new Docker image
./pullNewImageFromDocker.sh $repoName $tagName $containerName

# Run Image as container
./runImage.sh $repoName $tagName $containerName '--rm -d -p 8123:80' ''