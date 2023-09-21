#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_status() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully installed $1.${NC}"
  else
    echo -e "${RED}Failed to install $1.${NC}"
    exit 1
  fi
}

# Step 1: Install software from apt_installs.txt
while IFS= read -r software
do
  sudo apt install -y "$software"
  check_status "$software"
done < apt_installs.txt

# Step 2: Run custom installations from custom_installs.sh
./custom_installs.sh
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully executed custom installations.${NC}"
else
    echo -e "${RED}Custom installations failed.${NC}"
    exit 1
fi
