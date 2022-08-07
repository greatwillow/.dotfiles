#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user as well as the download of the dotfiles
# directory such that the install script can be executed with the 
# needed dependencies

cd $HOME

CURRENT_USER=$(whoami)
SHOULD_CREATE_NEW_USER="false"
IS_MAC_OS="false"
IS_LINUX_OS="false"
[[ "$OSTYPE" == "darwin"* ]] && IS_MAC_OS="true"
[[ "$OSTYPE" == "linux"* ]] && IS_LINUX_OS="true"

print_line() {
	printf "\n$1\n"
}

print_users_list() {
	print "Current available non root users are:"
	grep ':/home' /etc/passwd | awk -F ':' '{print $1}'
}

if [[ $IS_LINUX_OS == "true" && $CURRENT_USER == "root" ]]; then
	print_line "It looks like you are currently logged in as a root user. This installation will only work for non root users."
fi

print_users_list
print_line "Would you like to create another user? (t or f)"
read SHOULD_CREATE_NEW_USER

if [[ $SHOULD_CREATE_NEW_USER == "t" ]]; then
	print_line "Please enter a new user name:"
	read USER_NAME
	sudo useradd -m $USER_NAME				# Add New User
	sudo usermod -a -G sudo $USER_NAME		# Add New User to sudoers group
	sudo passwd $USER_NAME					# Prompt for password for new user
fi

print_users_list 
print_line "Enter the username from the above list which you would like to install this system on."
read LOGIN_USER

su - $LOGIN_USER							# Login as selected user
bash
CURRENT_USER=$(whoami)
echo "You are currently now logged in as $CURRENT_USER with home path at $HOME"

DOTFILES_DIRECTORY="$HOME/.dotfiles"
DOTFILES_TAR_FILE="$HOME/.dotfiles.tar.gz"
USE_DEFAULT_DOTFILES_REPO_AND_BRANCH="t"
GH_USER="greatwillow"
GH_REPO=".dotfiles"
GH_BRANCH="main"

print_line "You are currently set to load dotfiles from the default repository and branch."
print_line "Would you like to continue with the default selection? (t or f)"
read USE_DEFAULT_DOTFILES_REPO_AND_BRANCH

if [[ USE_DEFAULT_DOTFILES_REPO_AND_BRANCH != "t" ]]; then
	print_line "What is the dotfiles github user name?"
	read GH_USER
	print_line "What is the dotfiles repository name?"
	read GH_REPO
	print_line "What is the dotfiles branch you would like to checkout?"
	read GH_BRANCH
fi

# Download the dotfiles project
curl "https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.tar.gz" -L -o "$HOME/.dotfiles.tar.gz"

# Extract the dotfiles project to the .dotfiles directory
tar -xzvf $DOTFILES_TAR_FILE

# [[ -e "$DOTFILES_DIRECTORY-${GH_BRANCH}" ]] && mv "$DOTFILES_DIRECTORY-${GH_BRANCH}" "$DOTFILES_DIRECTORY"
mv "$DOTFILES_DIRECTORY-${GH_BRANCH}" $DOTFILES_DIRECTORY

rm -f $DOTFILES_TAR_FILE

cd $DOTFILES_DIRECTORY

sh install.sh