#!/bin/bash
log_file="webhook.log"

module_name="pomodoro.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

log "DEBUG" "Start $module_name script"

# Stop running docker container
command_output=$(sudo docker stop pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Stop container successfully: $command_output"
else
    log "ERROR" "Stop container faild: $command_output"
fi

# Remove old docker image
# Sleep for 7 seconds
sleep 7
command_output=$(sudo docker image rm eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Old Image removed successfully: $command_output"
else
    log "ERROR" "Old Image removing faild: $command_output"
fi

# Pull new image from docker
sleep 5
command_output=$(sudo docker pull eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Docker pull Image successfully: $command_output"
else
    log "ERROR" "Docker pull Image faild: $command_output"
fi

# Run new image
sleep 5
command_output=$(sudo docker run -p 8123:80 -d --rm --name pomodoro eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log "DEBUG" "Docker run Image successfully: $command_output"
else
    log "ERROR" "Docker run Image faild: $command_output"
fi