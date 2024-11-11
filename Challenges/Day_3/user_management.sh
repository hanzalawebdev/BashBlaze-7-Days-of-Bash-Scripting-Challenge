#!/bin/bash

<<note
Usage: ./user_management.sh [Options]
note

# Function to display_usage information
function display_usage {
        echo "Usage: ./user_management.sh [Options]"
        echo "Options:"
        echo "-c, --create      Create a new user account."
        echo "-d, --delete      Delete an exsisting user account."
        echo "-r, --reset       Reset Password for an existing user account."
        echo "-l, --list        List all user accounts on the system."
        echo "-h, --help        Display this help asnd exit."
}

# Function to create a new user account
function create_user {
        read -p "Enter the new username: " new_user

        # Check if the username already exists
        if id "$new_user" &>/dev/null; then
                echo "Error: The username '$username' already exists. Please choose a different username."
                exit 1
        else
                # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
                read -p "Enter password for $new_user : " $password
                
                # Create the user account
                sudo useradd -m -p "$password" "$new_user"
                echo "User $new_user created succesfully"
        fi
}

# Function to delete an existing user account
function delete_user {
        read -p "Enter the user to delete: " username

        # Check if the username exists
        if id $username &>/dev/null; then
                userdel -r "$username" # -r removes the user's home directory
                echo "User account $username deleted successfully."
        else
                echo "Error: The username '$username' does not exsist. Please enter a valid username."
        fi
}

# Function to reset a password
function reset_passwd {
        read -p "Enter the username to reset passowrd: " reset

        # Check user exists
        if id "$reset" &>/dev/null; then
                read -sp "Enter the new password for $reset : " password

                # set the new password
                echo "$reset:$password" | chpasswd
                echo "Password for user '$reset' reset successfully."

        else
                echo "Error: The username '$reset' does not exist. Please enter a valid username."
        fi
}

# Function to list all user accounts on the system
function list_users {
        echo "User accounts on the system:"
        cat /etc/passwd | awk -F: '{ print "- " $1 " (UID: " $3 ")" }'
}

# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        display_usage
        exit 0
fi

# Command-line argument parsing
while [ $# -gt 0 ]; do
        case "$1" in
                -c | --create)
                        create_user
                        ;;
                -d|--delete)
                        delete_user
                        ;;
                -r|--reset)
                        reset_passwd
                        ;;
                -l|--list)
                        list_users
                        ;;
                *)
                        echo "Error: Invalid option '$1'. Use '--help' to see available options."
                        exit 1
                        ;;
        esac
        shift
done
