#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Install stow
sudo apt install -y stow

# Create the dotfiles directory and cd into it
mkdir -p $DOTFILES_DIR
cd $DOTFILES_DIR

# Clone the repo into the dotfiles directory
git clone $REPO .

# Copy initial files
cp $HOME/.bashrc bash/
cp $HOME/.gitconfig git/
cp $HOME/.vimrc vim/

# For VS Code
mkdir -p vscode
cp $HOME/.config/Code/User/settings.json vscode/

# Use stow to create symlinks
stow bash vscode git vim

# Git setup
git add .
git commit -m "Initial commit of dotfiles"
git push

echo "Dotfiles setup and pushed to GitHub."
