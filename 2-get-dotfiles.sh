#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user as well as the download of the dotfiles
# directory such that the install script can be executed with the 
# needed dependencies

print_line() {
	printf "\n$1\n"
}

bash
cd $HOME
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