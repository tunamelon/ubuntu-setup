#!/bin/bash

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
