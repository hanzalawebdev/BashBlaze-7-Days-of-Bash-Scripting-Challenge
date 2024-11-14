#!/bin/bash

<<usage
Usage: ./monitor-proc.sh <process-name>
usage

# specify the target process to monitor
process_name=$1

# Process Existence Check:
check_process() {
        if pgrep -x "$process_name" > /dev/null; then
                echo "Process '$process_name' is currently running."
                return 0
        else
                echo "Process '$process_name' is not running."
                return 1
        fi
}

# Restart the process
restart_process() {
        echo "Process $process_name is not running. Attempting to restart..."

        # Check if the process is still not running before trying to restart
        if ! pgrep -x "$process_name" > /dev/null; then
                if sudo systemctl restart "$process_name"; then
                        echo "Process $process_name started successfully."
                else
                        echo "Failed to restart $process_name. Please check the process manually."
                        exit 1
                fi
        else
                echo "Process $process_name is already running."
        fi
}


# Check if a process name is provided as an argument
if [ $# -eq 0 ]; then
        echo "Usage: $0 <process-name>"
        exit 1
fi

max_attempts=3
attempts=0

# Loop to check and restart the process
while [ $attempts -lt $max_attempts ]; do

        if check_process "$process_name"; then
                echo "Process '$process_name' is running."
        else
                restart_process "$process_name"
        fi

        attempts=$((attempts + 1))
        sleep 5 # wait for 5 seconds
done

echo "Maximum restart attempts reached. Please check the process manually."
