#!/bin/bash

# This file is used to manage the initial download of the dotfiles
# directory such that the install script can be executed with the 
# needed dependencies

cd $HOME

USE_DEFAULT_DOTFILES_REPO_AND_BRANCH="t"
GH_USER="greatwillow"
GH_REPO=".dotfiles"
GH_BRANCH="main"

echo "You are currently set to load dotfiles from the default repository and branch."
echo "Would you like to continue with the default selection? (t or f)"
read USE_DEFAULT_DOTFILES_REPO_AND_BRANCH

if [[ USE_DEFAULT_DOTFILES_REPO_AND_BRANCH != "t" ]]; then
	echo "What is the dotfiles github user name?"
	read GH_USER
	echo "What is the dotfiles repository name?"
	read GH_REPO
	echo "What is the dotfiles branch you would like to checkout?"
	read GH_BRANCH
fi

# Download the dotfiles project
curl https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.tar.gz -o $HOME/.dotfiles.tar.gz -L

# Extract the dotfiles project to the .dotfiles directory
tar -xzvf $HOME/.dotfiles.tar.gz -C $HOME/.dotfiles

rm -f $HOME/.dotfiles.tar.gz

cd .dotfiles

sh install.sh