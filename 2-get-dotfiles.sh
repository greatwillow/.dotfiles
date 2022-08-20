#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user as well as the download of the dotfiles
# directory such that the install script can be executed with the 
# needed dependencies

gh_user="greatwillow"
gh_repo=".dotfiles"
gh_branch="main"
dotfiles_url="https://github.com/${gh_user}/${gh_repo}/archive/refs/heads/${gh_branch}.tar.gz"

#===============================================================================
# Functions
#===============================================================================

source _common_functions

query_for_alternate_dotfiles_url() {
	print_line "You are currently set to load dotfiles from $dotfiles_url"
	print_line "Would you like to continue with the default selection? (y or n)"
	read use_default_dotfiles_url

	if [[ $use_default_dotfiles_url != "y" ]]; then
		print_line "What is the dotfiles url you would like to use?"
		read dotfiles_url
		print_line "What branch of this repository would you like to use?"
		read gh_branch
	fi
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
query_for_alternate_dotfiles_url
download_and_extract_dotfiles $dotfiles_url
