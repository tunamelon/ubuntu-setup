# ubuntu-setup
Install script to install default software after fresh install

Initial_setup.sh
- This file is meant to be run by the user, and will result in the system updating, git installing, pulling this repo, then installing any apt programs found in apt_installs.txt, then installing the custom installs i.e. VS Code in custom_installs.sh
  
apt_installs.txt
- To be updated to include all the software to be auto installed
  
custom_installs.sh
- Includes any other kind of installs requiring more steps than apt install <app name> 
