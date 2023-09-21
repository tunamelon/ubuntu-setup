#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Install stow
sudo apt install -y stow

# Set up the dotfiles directory and navigate to it
mkdir -p $DOTFILES_DIR
cd $DOTFILES_DIR

# Check if git is initialized in the directory
if [ ! -d ".git" ]; then
    # Initialize git, add remote, and create the main branch
    git init
    git remote add origin $REPO
    git checkout -b main
fi

# Create the necessary directories, only if they don't already exist
for dir in bash git vim vscode; do
    mkdir -p $dir
done

# Copy initial files if they exist
[[ -f $HOME/.bashrc ]] && cp -u $HOME/.bashrc bash/
[[ -f $HOME/.gitconfig ]] && cp -u $HOME/.gitconfig git/
[[ -f $HOME/.vimrc ]] && cp -u $HOME/.vimrc vim/
[[ -f $HOME/.config/Code/User/settings.json ]] && cp -u $HOME/.config/Code/User/settings.json vscode/

# Use stow to create symlinks
stow bash vim git vscode

# Git setup
git add .
git commit -m "Initial commit of dotfiles"
git push -u origin main

echo "Dotfiles setup and pushed to GitHub."
