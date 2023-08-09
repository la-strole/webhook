#!/bin/bash
log_file="../webhook.log"

module_name="pomodoro.sh"

log() {
    local timestamp
    timestamp=$(date +"%b %d %T")
    local level="$1"
    local message="$2"
    echo "<$level>$timestamp $module_name script: $message" >> "$log_file"
}

log 6 "Start $module_name script"

# Stop running docker container
command_output=$(sudo docker stop pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log 6 "Stop container successfully: $command_output"
else
    log 3 "Stop container faild: $command_output"
fi

# Remove old docker image
# Sleep for 7 seconds
sleep 7
command_output=$(sudo docker image rm eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log 6 "Old Image removed successfully: $command_output"
else
    log 3 "Old Image removing faild: $command_output"
fi

# Pull new image from docker
sleep 5
command_output=$(sudo docker pull eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log 6 "Docker pull Image successfully: $command_output"
else
    log 3 "Docker pull Image faild: $command_output"
fi

# Run new image
sleep 5
command_output=$(sudo docker run -p 8123:80 -d --rm --name pomodoro eugeneparkhom/pomodoro 2>&1)
# Check if the command was successful or resulted in an error
if [ $? -eq 0 ]; then
    log 6 "Docker run Image successfully: $command_output"
else
    log 3 "Docker run Image faild: $command_output"
fi