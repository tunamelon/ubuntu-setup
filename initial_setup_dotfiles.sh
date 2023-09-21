#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Install stow
sudo apt install -y stow

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    # If not, clone the repo into the dotfiles directory
    git clone $REPO $DOTFILES_DIR
else
    # If exists, pull latest changes
    cd $DOTFILES_DIR
    git pull
fi

# Navigate to dotfiles directory
cd $DOTFILES_DIR

# Copy initial files if they exist
[[ -f $HOME/.bashrc ]] && cp -u $HOME/.bashrc bash/
[[ -f $HOME/.gitconfig ]] && cp -u $HOME/.gitconfig git/
[[ -f $HOME/.vimrc ]] && cp -u $HOME/.vimrc vim/

# For VS Code
[[ -f $HOME/.config/Code/User/settings.json ]] && mkdir -p vscode && cp -u $HOME/.config/Code/User/settings.json vscode/

# Use stow to create symlinks
[ -d "bash" ] && stow bash
[ -d "vim" ] && stow vim
[ -d "git" ] && stow git
[ -d "vscode" ] && stow vscode

# Git setup
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Update dotfiles"
    git push
else
    echo "No changes to commit"
fi

echo "Dotfiles setup and pushed to GitHub."
