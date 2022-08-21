#!/bin/bash

sudo chsh -s $(which bash) $USER

curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/_common_functions -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/1-setup-user.sh -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/2-get-dotfiles.sh -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/3-install-nix.sh -O 
curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/4-install-packages.sh -O

source 1-setup-user.sh

print_line "Enter the username from the above list which you would like to install this system on."
read selected_user

echo "You are currently switching to another prompt as user: $selected_user"
echo ""

su -P -s $(which bash) -l $selected_user -c "cd /personal-setup-scripts; bash 2-get-dotfiles.sh; bash 3-install-nix.sh;"