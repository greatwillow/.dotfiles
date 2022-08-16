#!/bin/bash

sudo chsh -s $(which bash) $USER

curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/_common_functions -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/1-setup-user.sh -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/2-get-dotfiles.sh -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/3-setup-environment.sh -O 

source 1-setup-user.sh

print_line "Enter the username from the above list which you would like to install this system on."
read selected_user
#su - $selected_user -c "cd /personal-setup-scripts; source 2-get-dotfiles.sh; source 3-setup-environment.sh"

sudo -i -u $selected_user bash << EOF
cd /personal-setup-scripts;
source 2-get-dotfiles.sh; 
source 3-setup-environment.sh
EOF