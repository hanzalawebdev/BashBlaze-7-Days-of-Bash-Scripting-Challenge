#!/bin/bash

<<note
This is a script for backup with 3 day rotation

Usage:
./backup-with-rotation.sh <path to your source> <Path to your backup directory>
note

# Function to display usage information and available options
function display_usage {
        echo "Usage:./backup-with-rotation.sh <path to your source> <Path to your backup directory>"
}

# Check if a valid directory path is provided as a command-line argument
if [ $# -eq 0 ] || [ ! -d "$1" ]; then
    echo "Error: Please provide a valid directory path as a command-line argument."
    display_usage
    exit 1
fi

source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

# Function to create a timestamped backup folder
function create_backup {
        zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
        if [ $? -eq 0 ]; then
                echo "backup generated successfully for ${timestamp}"
        fi
}

# Function to perform the rotation and keep only the last 3 backups
function perform_rotation {
        backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))

        if [ "${#backups[@]}" -gt 3 ]; then
                echo "performing rotation for 3 days"
                backups_to_remove=("${backups[@]:3}")
                for backup in "${backups_to_remove[@]}";
                do
                        rm -f ${backup}
                done
        fi
}

# Main script logic
create_backup
perform_rotation
