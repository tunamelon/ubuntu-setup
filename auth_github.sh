#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

check_for_existing_keys() {
    if [[ -f ~/.ssh/github_rsa ]]; then
        return 0
    else
        return 1
    fi
}

generate_ssh_key() {
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_rsa -N "" -C "your_email@example.com"
}

display_and_copy_key() {
    echo -e "${GREEN}Your GitHub SSH public key:${NC}"
    cat ~/.ssh/github_rsa.pub
    # Attempt to copy to clipboard
    sudo apt install -y xclip
    if command -v xclip > /dev/null; then
        cat ~/.ssh/github_rsa.pub | xclip -selection clipboard
        echo "Key copied to clipboard."
    fi
}

wait_for_github_setup() {
    echo -e "\nPlease add the above key to your GitHub account SSH settings."
    read -p "Press enter when you have added the key to GitHub..."
}

test_github_connection() {
    echo "Testing connection to GitHub..."
    ssh -T git@github.com -o IdentitiesOnly=yes -i ~/.ssh/github_rsa 2>&1 | grep "You've successfully authenticated"
}

setup_me() {
    git config --global user.email "tuna@sodamelon.com"
    git config --global user.name "Tuna"
    git config --global init.defaultBranch main
}

main_logic() {
    if check_for_existing_keys; then
        echo "GitHub SSH key found."
        if ! test_github_connection; then
            echo -e "${RED}However, authentication with GitHub failed.${NC}"
            display_and_copy_key
            wait_for_github_setup
        fi
    else
        echo "Generating new GitHub SSH key..."
        generate_ssh_key
        display_and_copy_key
        wait_for_github_setup
    fi

    # Test GitHub connection after setup
    if ! test_github_connection; then
        echo -e "${RED}Failed to authenticate with GitHub. Please ensure you've added the key correctly.${NC}"
    else
        setup_me
        echo -e "${GREEN}Successfully authenticated with GitHub.${NC}"
    fi
}

main_logic
