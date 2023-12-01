#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

# Functions

check_status() {
    # Checks if process failed and prints error
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR] $1${NC}"  # Print the error message passed as the first argument in red
        exit 1
    fi
}

update_upgrade_system() {
    # Update and upgrade the system
    echo -e "${GREEN}Updating and upgrading the system...${NC}"
    sudo apt update && sudo apt upgrade -y
    check_status "Failed to update and upgrade the system."
    echo -e "${GREEN}System update and upgrade successful.${NC}"
}

install_git() {
    # Install git
    echo -e "${GREEN}Installing git...${NC}"
    sudo apt install -y git
    check_status "Failed to install git."
    echo -e "${GREEN}Git installation successful.${NC}"
}

make_scripts_dir() {
    # Create the directory for the setup scripts
    echo -e "${GREEN}Setting up scripts directory...${NC}"
    mkdir -p ~/scripts
    check_status "Failed to create the ~/scripts directory."
    echo -e "${GREEN}Scripts directory setup successful.${NC}"
}

clone_setup_repo() {
    # Go to scripts
    cd ~/scripts
    
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
    git remote set-url origin git@github.com:tunamelon/ubuntu-setup.git

}

make_scripts_executable() {    
    # Make scripts executable
    echo -e "${GREEN}Making scripts executable...${NC}"
    chmod +x *.sh
    check_status "Failed to make scripts executable."
    echo -e "${GREEN}Scripts made executable successfully.${NC}"
}

setup_dotfiles() {
    # Setup dotfiles
    echo "Set them up here"
}

install_software() {    
    # Run main install script
    echo -e "${GREEN}Running main install script...${NC}"
    bash main_install.sh
    check_status "Failed to run main_install.sh."
    echo -e "${GREEN}Main install script executed successfully.${NC}"
}

# Main logic #

# Check if the script is run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}It's recommended to run this script as a regular user, not as root.${NC}"
    read -p "Are you sure you want to run this as root? Type YES to continue: " confirmation
    if [ "$confirmation" != "YES" ]; then
        echo "Exiting..."
        exit 1
    fi
fi

# Logic run order
update_upgrade_system
# Initiates Ubuntu pro for live updates
sudo pro attach C12JSPs8qUmhfBr1HxN2dSnCAFxJvP

install_git
make_scripts_dir
clone_setup_repo
make_scripts_executable
bash auth_github.sh
install_software
bash sudo ssh_setup.sh

echo -e "${GREEN}System setup complete${NC}"
