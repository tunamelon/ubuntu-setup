#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Clone the repository
if [[ ! -d $DOTFILES_DIR ]]; then
    mkdir -p $DOTFILES_DIR
    git clone $REPO $DOTFILES_DIR
else
    echo "$DOTFILES_DIR already exists. Pulling the latest changes..."
    cd $DOTFILES_DIR
    git pull origin master
fi

# Navigate to the dotfiles directory
cd $DOTFILES_DIR

# Use stow to symlink the files
stow bash vscode git vim

echo "Restoration complete."
