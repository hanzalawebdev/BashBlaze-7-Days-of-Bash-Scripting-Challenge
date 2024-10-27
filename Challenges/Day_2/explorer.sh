#!/bin/bash

# Part1: Files & Directory Exploration
echo "Welcome to the Interactive File and Directory Explorer!"

while true; do

    # List all files and directories in the current path
    echo "Files and Directories in the Current Path: "
    ls -lh

    # Part2: Character Counting
    read -p "Enter a line of text (Press Enter without text to exit): " input

    # Exits when the input are empty
    if [[ -z "$input" ]]; then
          echo "Exiting the Interactive Explorer. Goodbye!"
          break
    fi

    # Calculate and print the character count for the input line
    char_count=$(echo -n "$input" | wc -m)
    echo "character count: $char_count"
done
