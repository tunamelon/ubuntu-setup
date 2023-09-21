#!/bin/bash

# Color codes for feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check the status of the last command and print feedback
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$1 successfully installed.${NC}"
    else
        echo -e "${RED}Failed to install $1.${NC}"
    fi
}

# Function to install Microsoft VS Code
install_vscode() {
    echo "Installing Microsoft VS Code..."

    wget -q https://packages.microsoft.com/keys/microsoft.asc -O microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

    sudo apt update
    sudo apt install -y code

    check_status "Microsoft VS Code"
}


# Call the installation functions
install_vscode

# For future custom installations, you can add more functions like install_vscode above and then call them at the bottom.
