#!/bin/bash
log_file="webhook.log"

module_name="testScript.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

log "INFO" "Start $module_name script"

# Stop running docker container
command_output=$(echo "test successfull" 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "INFO" "test script run: $command_output"
else
    log "ERROR" "test script faild: $command_output"
fi