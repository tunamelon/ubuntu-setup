#!/bin/bash

# Ensure the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Install OpenSSH Server without interactive prompts
echo "Installing OpenSSH Server..."
apt-get install -y openssh-server

# Ensure SSH is running
echo "Ensuring SSH service is running..."
systemctl start ssh
systemctl enable ssh
systemctl status ssh

# Set up SSH Key-Based Authentication
echo "Copying public key for SSH Key-Based Authentication..."
mkdir -p ~/.ssh
cat ./publickey/id_rsa_ssh-ubuntu.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# Install VNC Server
echo "Installing TightVNCServer..."
apt-get install -y tightvncserver

# Set up VNC Password Non-Interactively using the pre-generated hashed password file
echo "Setting up VNC Password..."
VNC_PASSWORD_FILE="./API/api"  # Corrected path to the pre-generated hashed password file
mkdir -p ~/.vnc
cp "$VNC_PASSWORD_FILE" ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Configure VNC to Start with the GNOME Desktop Environment
echo "Configuring VNC Server for GNOME Desktop..."
cat <<EOT > ~/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
gnome-session &
EOT

# Make the xstartup script executable
chmod +x ~/.vnc/xstartup

# Start VNC Server
echo "Starting VNC Server..."
vncserver -geometry 1920x1080

echo "Setup complete."
