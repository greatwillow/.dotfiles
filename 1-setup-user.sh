#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user.

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