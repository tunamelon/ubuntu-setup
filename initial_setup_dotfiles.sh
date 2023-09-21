# Variables
DOTFILES_DIR="$HOME/dotfiles"
REPO="git@github.com:tunamelon/ubuntu-dotfiles.git"

# Install stow
sudo apt install -y stow

# Create the dotfiles directory and cd into it
mkdir -p $DOTFILES_DIR
cd $DOTFILES_DIR

# Clone the repo into the dotfiles directory
if [ ! -d ".git" ]; then
    git clone $REPO .
fi

# Function to backup and stow
backup_and_stow() {
    local dir_name=$1
    local file_name=$2

    # If the file exists and is NOT a symbolic link, back it up
    if [ -e "$HOME/$file_name" ] && [ ! -L "$HOME/$file_name" ]; then
        mv "$HOME/$file_name" "$HOME/$file_name.bak"
    fi

    # Create the directory if it doesn't exist
    mkdir -p "$DOTFILES_DIR/$dir_name"

    # Copy the file if it doesn't exist in the dotfiles directory
    if [ ! -e "$DOTFILES_DIR/$dir_name/$file_name" ]; then
        cp "$HOME/$file_name" "$DOTFILES_DIR/$dir_name/"
    fi

    # Stow the directory
    stow --restow $dir_name
}

backup_and_stow bash .bashrc
backup_and_stow git .gitconfig

# If .vimrc exists, do the same for vim
if [ -e "$HOME/.vimrc" ]; then
    backup_and_stow vim .vimrc
fi

# If VS Code settings exist, do the same for vscode
if [ -e "$HOME/.config/Code/User/settings.json" ]; then
    mkdir -p "$DOTFILES_DIR/vscode"
    cp -r "$HOME/.config/Code/User/" "$DOTFILES_DIR/vscode/"
    stow --restow vscode
fi

# Git setup
git add .
git commit -m "Initial commit of dotfiles"
git push origin main

echo "Dotfiles setup and pushed to GitHub."
