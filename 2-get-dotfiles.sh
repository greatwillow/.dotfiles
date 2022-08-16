#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user as well as the download of the dotfiles
# directory such that the install script can be executed with the 
# needed dependencies

gh_user="greatwillow"
gh_repo=".dotfiles"
gh_branch="main"

#===============================================================================
# Functions
#===============================================================================

source _common_functions

get_dotfiles_url() {
	print_line "You are currently set to load dotfiles from the default repository and branch."
	print_line "Would you like to continue with the default selection? (y or n)"
	read use_default_dotfiles_and_branch

	if [[ $use_default_dotfiles_and_branch != "y" ]]; then
		print_line "What is the dotfiles github user name?"
		read gh_user
		print_line "What is the dotfiles repository name?"
		read gh_repo
		print_line "What is the dotfiles branch you would like to checkout?"
		read gh_branch
	fi

	return "https://github.com/${gh_user}/${gh_repo}/archive/refs/heads/${gh_branch}.tar.gz"
}

download_and_extract_dotfiles() {
	local dotfiles_directory="$HOME/.dotfiles"
	local dotfiles_tar_file="$HOME/.dotfiles.tar.gz"

	curl $1 -L -o "$HOME/.dotfiles.tar.gz"

	tar -xzvf $dotfiles_tar_file
	mv "$dotfiles_directory-${gh_branch}" $dotfiles_directory
	rm -f $dotfiles_tar_file
}

#===============================================================================
# Program
#===============================================================================

cd $HOME
current_user=$(whoami)
print_line "You are currently now logged in as $current_user with home path at $HOME"
dotfiles_url=get_dotfiles_url
download_and_extract_dotfiles $dotfiles_url
