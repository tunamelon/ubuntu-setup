#!/bin/bash

# Define paths for service and timer for the user 'tuna'
USER_SYSTEMD_DIR="$HOME/.config/systemd/user/"
SERVICE_PATH="${USER_SYSTEMD_DIR}dotfiles_backup.service"
TIMER_PATH="${USER_SYSTEMD_DIR}dotfiles_backup.timer"

setup_service_and_timer() {
    # Ensure the directory exists
    mkdir -p $USER_SYSTEMD_DIR

    # Ensure backup script is executable
    chmod +x $(pwd)/backup_dotfiles.sh

    # Create the service file
    cat > $SERVICE_PATH <<EOL
[Unit]
Description=Backup dotfiles

[Service]
Type=oneshot
ExecStart=$(pwd)/backup_dotfiles.sh
EOL

    # Create the timer file
    cat > $TIMER_PATH <<EOL
[Unit]
Description=Run dotfiles backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOL

    # Reload systemd to recognize the new service and timer for the user
    systemctl --user daemon-reload

    # Enable and start the timer
    systemctl --user enable dotfiles_backup.timer
    systemctl --user start dotfiles_backup.timer

    echo "Dotfiles backup service and timer setup completed for user."
}

# Check if service and timer exist
if [[ -f $SERVICE_PATH && -f $TIMER_PATH ]]; then
    echo "Service and timer files exist for user."

    # Check if the service and timer are working
    if systemctl --user is-active --quiet dotfiles_backup.timer; then
        echo "Service and timer are active and working for user. Exiting."
        exit 0
    else
        read -p "Service and timer are not working. Do you want to reinstall them for user? (y/n): " choice
        if [[ $choice == 'y' || $choice == 'Y' ]]; then
            setup_service_and_timer
        else
            echo "Exiting without any changes."
            exit 0
        fi
    fi
else
    echo "Service and timer files do not exist for user. Setting them up now."
    setup_service_and_timer
fi
