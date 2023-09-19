#!/bin/bash

# Step 1: Install software from apt_installs.txt
while IFS= read -r software
do
  sudo apt install -y "$software"
done < apt_installs.txt

# Step 2: Run custom installations from custom_installs.sh
./custom_installs.sh
