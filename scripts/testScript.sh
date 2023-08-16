#!/bin/bash
log_file="webhook.log"

module_name="testScript.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"
containerName="$3"

log "INFO" "Initiating the $module_name script"

# Cease the operation of the active Docker container
command_output=$(echo "Test successful. repoName=$repoName, tagName=$tagName, containerName=$containerName")
# Determine if the command executed successfully or resulted in an error
if [ $? -eq 0 ]; then
    log "INFO" "Test script executed: $command_output"
else
    log "ERROR" "Test script failed: $command_output"
fi
