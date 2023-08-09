#!/bin/bash
log_file="../webhook.log"

module_name="testScript.sh"

log() {
    local timestamp
    timestamp=$(date +"%b %d %T")
    local level="$1"
    local message="$2"
    echo "<$level>$timestamp $module_name script: $message" >> "$log_file"
}

log 6 "Start $module_name script"

# Stop running docker container
command_output=$(echo "test successfull" 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log 6 "test script run: $command_output"
else
    log 3 "test script faild: $command_output"
fi