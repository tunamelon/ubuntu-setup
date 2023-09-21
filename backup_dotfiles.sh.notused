#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Check if the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory not found. Please ensure it's set up correctly."
    exit 1
fi

cd $DOTFILES_DIR

# Backup current files to the dotfiles directory

# bash, git, and vim
cp $HOME/.bashrc bash/
cp $HOME/.gitconfig git/
cp $HOME/.vimrc vim/

# VS Code
cp $HOME/.config/Code/User/settings.json vscode/

# Commit and push changes to the repository
git add .
git commit -m "Backup dotfiles on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin master

echo "Dotfiles backed up and pushed to GitHub."
