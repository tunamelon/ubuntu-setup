#!/bin/bash

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="https://github.com/tunamelon/ubuntu-dotfiles"
PROFILE_DIR=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed 's/^Path=//')
BOOKMARKS_BACKUP="$DOTFILES_DIR/firefox/firefox_bookmarks.json"

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

# Firefox
# Export Firefox bookmarks
firefox -headless -CreateProfile "backup-temp"
firefox -headless -P "backup-temp" bookmarkbackups/export > $BOOKMARKS_BACKUP
# Backup prefs.js
cp ~/.mozilla/firefox/$PROFILE_DIR/prefs.js firefox/

# Commit and push changes to the repository
git add .
git commit -m "Backup dotfiles on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin master

# Remove temporary Firefox profile
firefox -headless -P "backup-temp" -quit
rm -r ~/.mozilla/firefox/*.backup-temp

echo "Dotfiles backed up and pushed to GitHub."
