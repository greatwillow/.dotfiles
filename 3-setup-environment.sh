#!/bin/sh

# Inspired originally by the following setup by Jake Weis 
# See: https://github.com/jakewies/.dotfiles
# With instructions here: https://www.youtube.com/watch?v=70YMTHAZyy4&list=PL1C97G3GhlHdANMFUIXTcFr14R7b7EBj9&index=1

DOTFILES_DIRECTORY="$HOME/.dotfiles"
BASE_CONFIG_DIRECTORY="$HOME/.config"
ZSH_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/zsh"
ZSH_PLUGINS_DIRECTORY="$ZSH_CONFIG_DIRECTORY/plugins"
ZSH_PLUGINS_TEXT_FILE="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.txt"
ZSH_PLUGINS_FILE="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.sh"
SHELLS_COMMON_CONFIG_DIRECTORY="$HOME/.config/sh"
EXPORTS_FILE="$SHELLS_COMMON_CONFIG_DIRECTORY/.exports"
ALIASES_FILE="$SHELLS_COMMON_CONFIG_DIRECTORY/.aliases"
ANTIDOTE_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/antidote"
POWERLEVEL10K_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/powerlevel10k"
ASDF_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/asdf"

print_line() {
	printf "\n$1\n"
}

print_header() {
	printf "\n-----------------------------------------------------------------\n$1\n------------------------------------------------------------------------------\n"
}

# Import Exports to be able check platform os type
source [[ -f $EXPORTS_FILE ]] && source $EXPORTS_FILE
# Import Aliases file in order to be able to use aliases here
source [[ -f $ALIASES_FILE ]] && source $ALIASES_FILE

#===============================================================================
# Nix
#===============================================================================
print_header "Installing Nix"
curl -L https://nixos.org/nix/install | sh

print_header "Sourcing Nix"
print_line "Enter Nix config path and press enter to source Nix."
read NIX_SHELL_CONFIG_PATH
[[ -e $NIX_SHELL_CONFIG_PATH ]] && source $NIX_SHELL_CONFIG_PATH

print_header "Installing Nix Packages"
nix-env -iA \
	nixpkgs.zsh \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.stow \
	nixpkgs.yarn \
	nixpkgs.fzf \
	nixpkgs.ripgrep \
	nixpkgs.bat

	# ---- ASDF ----
	# nixpkgs.asdf-vm

	# ---- Tmux ----
	# nixpkgs.tmux \

	# ---- Other Graphical UI Programs I use ----
	# nixpkgs.enpass \
	# nixpkgs.obsidian \
	# nixpkgs.vscode \
	# nixpkgs.spotify

	# ---- Direnv ----
	# allows for localized env variables
	# See -> https://shivamarora.medium.com/a-guide-to-manage-your-environment-variables-in-a-better-way-using-direnv-2c1cd475c8e
	# Also See -> https://www.youtube.com/watch?v=YkxoGRpHcVQ
	# nixpkgs.direnv

	# ---- GnuMake ----
	# nixpkgs.gnumake \

	# ---- Gnu Compiler Collection ----
	# Used to compile different languages
	# nixpkgs.gcc \

#===============================================================================
# Stow
#===============================================================================
print_header "Stowing dotfiles"
cd $DOTFILES_DIRECTORY
stow shells_common_configuration
stow git
stow nvim
# stow tmux
stow zsh

#===============================================================================
# Git
#===============================================================================
print_header "Setting up Github SSH key pairs."
print_line "Please enter your github email."
read github_email
ssh-keygen -t rsa -b 4096 -C $github_email

print_header "Starting ssh-agent in the background."
eval "$(ssh-agent -s)"

print_header "Adding your SSH key to ssh-agent."
ssh-add ~/.ssh/id_rsa

print_header "Copying SSH key to your clipboard."
pbcopy < ~/.ssh/id_rsa.pub

print_header "Add key to github to finish setup."
print_line "Press enter to open instructions."
read throwaway_input
open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
open https://github.com/settings/keys

#===============================================================================
# Zsh
#===============================================================================
print_header "Setting up Zsh and Antidote package manger"
# Clone antidote if necessary
[[ -e $ANTIDOTE_CONFIG_DIRECTORY ]] || git clone https://github.com/mattmc3/antidote.git $ANTIDOTE_CONFIG_DIRECTORY
# Add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells
# Use zsh as default shell
sudo chsh -s $(which zsh) $USER

#===============================================================================
# Powerlevel 10k
#===============================================================================
print_header "Installing Powerlevel 10k"
[[ -e $POWERLEVEL10K_CONFIG_DIRECTORY ]] || git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $POWERLEVEL10K_CONFIG_DIRECTORY

#===============================================================================
# Nvim
#===============================================================================
print_header "Installing Neovim Plugins"
# nvim --headless +PlugInstall +qall

#===============================================================================
# Version Management -> Asdf for mac/linux and N for Windows
#===============================================================================
if [[ IS_WINDOWS_OS == "false" ]]; then
	print_header "Setting up Asdf version manager"
	# Download ASDF
	[[ -e $ASDF_CONFIG_DIRECTORY ]] || git clone https://github.com/asdf-vm/asdf.git $ASDF_CONFIG_DIRECTORY --branch v0.10.2
	# Import ASDF
	[[ -e $ASDF_CONFIG_DIRECTORY/asdf.sh ]] && source $ASDF_CONFIG_DIRECTORY/asdf.sh
fi

#===============================================================================
# TODO's
#===============================================================================
# TODO: Remove this in favor of Alacritty
# [[ "$IS_MAC_OS" == "true" ]] && stow kitty

# TODO: Look at how to get npm installed ahead of this so can install
# the following global npm modules
# npm install --global trash-cli