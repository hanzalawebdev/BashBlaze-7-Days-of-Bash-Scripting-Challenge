#!/bin/bash

<<note
Usage: - ./usr_interaction_with_metrics.sh
note

# Function to display system metrics (CPU, memory, disk space)
view_system_metrics() {
        echo "---- System Metrics ----"
        # Fetch CPU usage using `top` command and extract the value using awk
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)  # Adjusted for correct field
        # Fetch memory usage using `free` command and extract the value using awk
        mem_usage=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100)}')
        # Fetch disk space usage using `df` command and extract the value using awk
        disk_usage=$(df -h / | tail -1 | awk '{print $5}')

        echo "CPU Usage: $cpu_usage%,   Mem Usage: $mem_usage%,         Disk Usage: $disk_usage"
}

monitor_specific_service() {
        read -p "Enter the name of the service to monitor: " service_name

        # Check if the service is running using "systemctl" command
        if systemctl is-active --quiet "$service_name"; then
                echo "$service_name is already running."
        else
                echo "$service_name is not running."
                read -p "Would you like to start the service? (Y/N): " choice
                if [[ "$choice" == "Y" ]] || [[ "$choice" == "y" ]]; then
                        sudo systemctl start "$service_name"
                        echo "$service_name started successfully."
                fi
        fi
}

# Main loop for continuous monitoring
while true; do
        echo "---- Monitoring Metrics Script ----"
        echo "1. View System Metrics"
        echo "2. Monitor a Specific Service"
        echo "3. Exit"

        read -p "Enter your choice (1, 2, or 3): " choice

        case $choice in
                1)
                        view_system_metrics
                        ;;
                2)
                        monitor_specific_service
                        ;;
                3)
                        echo "Exiting the Script! Goodbye!!!"
                        exit 0
                        ;;
                *)
                        echo "Error: Invalid option. Please choose a valid option (1, 2, or 3)."
                        ;;
        esac

        sleep 5
done
