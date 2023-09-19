#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "It's recommended to run this script as a regular user, not as root."
    read -p "Are you sure you want to run this as root? Type YES to continue: " confirmation
    if [ "$confirmation" != "YES" ]; then
        echo "Exiting..."
        exit 1
    fi
fi

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install git
sudo apt install -y git

# Create the directory for the setup scripts
mkdir -p ~/scripts

# Change directory
cd ~/scripts

# Clone the repository
git clone https://github.com/tunamelon/ubuntu-setup.git

# Change into the cloned directory and run the main install script
cd ubuntu-setup
bash main_install.sh
