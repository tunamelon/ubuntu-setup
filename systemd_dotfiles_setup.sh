#!/bin/bash

# Define paths for service and timer
SERVICE_PATH="/etc/systemd/system/dotfiles_backup.service"
TIMER_PATH="/etc/systemd/system/dotfiles_backup.timer"

setup_service_and_timer() {
    # Ensure backup script is executable
    chmod +x $(pwd)/backup_dotfiles.sh

    # Create the service file
    sudo bash -c "cat > $SERVICE_PATH" <<EOL
[Unit]
Description=Backup dotfiles

[Service]
Type=oneshot
ExecStart=$(pwd)/backup_dotfiles.sh
EOL

    # Create the timer file
    sudo bash -c "cat > $TIMER_PATH" <<EOL
[Unit]
Description=Run dotfiles backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOL

    # Reload systemd to recognize the new service and timer
    sudo systemctl daemon-reload

    # Enable and start the timer
    sudo systemctl enable dotfiles_backup.timer
    sudo systemctl start dotfiles_backup.timer

    echo "Dotfiles backup service and timer setup completed."
}

# Check if service and timer exist
if [[ -f $SERVICE_PATH && -f $TIMER_PATH ]]; then
    echo "Service and timer files exist."

    # Check if the service and timer are working
    if sudo systemctl is-active --quiet dotfiles_backup.timer; then
        echo "Service and timer are active and working. Exiting."
        exit 0
    else
        read -p "Service and timer are not working. Do you want to reinstall them? (y/n): " choice
        if [[ $choice == 'y' || $choice == 'Y' ]]; then
            setup_service_and_timer
        else
            echo "Exiting without any changes."
            exit 0
        fi
    fi
else
    echo "Service and timer files do not exist. Setting them up now."
    setup_service_and_timer
fi
