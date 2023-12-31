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
if systemctl is-active --quiet ssh; then
    echo "SSH service is running."
else
    echo "SSH service is not running. Exiting script."
    exit 1
fi

# Set up SSH Key-Based Authentication
echo "Copying public key for SSH Key-Based Authentication..."
mkdir -p ~/.ssh
cat /home/tuna/scripts/ubuntu-setup/publickey/id_rsa_ssh-ubuntu.pub >> /home/tuna/.ssh/authorized_keys
chown -R tuna:tuna /home/tuna/.ssh
chmod 600 /home/tuna/.ssh/authorized_keys
chmod 700 /home/tuna/.ssh

# Set up SSH Config
sudo cp /home/tuna/scripts/ubuntu-setup/ssconfig /etc/ssh/sshd_config
sudo systemctl restart ssh

# Set up firewall for ssh
sudo ufw allow ssh
sudo ufw enable

# Install VNC Server
echo "Installing TightVNCServer..."
apt-get install -y tightvncserver

# Set up VNC Password Non-Interactively using the pre-generated hashed password file
echo "Setting up VNC Password..."
VNC_PASSWORD_FILE="/home/tuna/scripts/ubuntu-setup/API_KEY/api"  # Corrected path to the pre-generated hashed password file
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
