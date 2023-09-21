#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Install stow
sudo apt install -y stow

# Navigate to or create the dotfiles directory
mkdir -p $DOTFILES_DIR
cd $DOTFILES_DIR

# Check if git is initialized in the directory
if [ ! -d ".git" ]; then
    # Initialize git and add remote if it's not already initialized
    git init
    git remote add origin $REPO
fi

# Pull latest changes from the remote repo
git pull origin main

# Create necessary directories if they don't exist
mkdir -p bash git vim vscode

# Copy initial files if they exist
[[ -f $HOME/.bashrc ]] && cp -u $HOME/.bashrc bash/
[[ -f $HOME/.gitconfig ]] && cp -u $HOME/.gitconfig git/
[[ -f $HOME/.vimrc ]] && cp -u $HOME/.vimrc vim/
[[ -f $HOME/.config/Code/User/settings.json ]] && cp -u $HOME/.config/Code/User/settings.json vscode/

# Use stow to create symlinks
stow bash vim git vscode

# Git setup
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Update dotfiles"
    git push -u origin main
else
    echo "No changes to commit"
fi

echo "Dotfiles setup and pushed to GitHub."
