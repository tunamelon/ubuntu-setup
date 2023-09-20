#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

# Function to check the last command's status
check_status() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR] $1${NC}"  # Print the error message passed as the first argument in red
        exit 1
    fi
}

# Check if the script is run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}It's recommended to run this script as a regular user, not as root.${NC}"
    read -p "Are you sure you want to run this as root? Type YES to continue: " confirmation
    if [ "$confirmation" != "YES" ]; then
        echo "Exiting..."
        exit 1
    fi
fi

# Update and upgrade the system
echo -e "${GREEN}Updating and upgrading the system...${NC}"
sudo apt update && sudo apt upgrade -y
check_status "Failed to update and upgrade the system."
echo -e "${GREEN}System update and upgrade successful.${NC}"

# Install git
echo -e "${GREEN}Installing git...${NC}"
sudo apt install -y git
check_status "Failed to install git."
echo -e "${GREEN}Git installation successful.${NC}"

# Create the directory for the setup scripts and change to it
echo -e "${GREEN}Setting up scripts directory...${NC}"
mkdir -p ~/scripts && cd ~/scripts
check_status "Failed to create and change to the ~/scripts directory."
echo -e "${GREEN}Scripts directory setup successful.${NC}"

# Clone the repository
echo -e "${GREEN}Cloning the repository...${NC}"
git clone https://github.com/tunamelon/ubuntu-setup.git
check_status "Failed to clone the repository."
echo -e "${GREEN}Repository clone successful.${NC}"

# Change into the cloned directory
echo -e "${GREEN}Changing to the ubuntu-setup directory...${NC}"
cd ubuntu-setup
check_status "Failed to change to the ubuntu-setup directory."
echo -e "${GREEN}Successfully changed to ubuntu-setup directory.${NC}"

# Make scripts executable
echo -e "${GREEN}Making scripts executable...${NC}"
chmod +x *.sh
check_status "Failed to make scripts executable."
echo -e "${GREEN}Scripts made executable successfully.${NC}"

# Run main install script
echo -e "${GREEN}Running main install script...${NC}"
bash main_install.sh
check_status "Failed to run main_install.sh."
echo -e "${GREEN}Main install script executed successfully.${NC}"
