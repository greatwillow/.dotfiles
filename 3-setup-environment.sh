#!/bin/sh

# Inspired originally by the following setup by Jake Weis 
# See: https://github.com/jakewies/.dotfiles
# With instructions here: https://www.youtube.com/watch?v=70YMTHAZyy4&list=PL1C97G3GhlHdANMFUIXTcFr14R7b7EBj9&index=1

base_config_directory="$HOME/.config"

#===============================================================================
# Functions
#===============================================================================

source _common_functions

install_nix() {
	print_header "Installing Nix"
	# Installing Nix for multi-user support - https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation
	sh <(curl -L https://nixos.org/nix/install) --daemon
}

source_nix() {
	print_header "Sourcing Nix"
	print_line "Enter Nix config path and press enter to source Nix."
	read nix_shell_config_path
	[[ -e $nix_shell_config_path ]] && source $nix_shell_config_path
}

install_nix_packages() {
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
}

stow_dotfiles() {
	local dotfiles_directory="$HOME/.dotfiles"

	print_header "Stowing dotfiles"
	cd $dotfiles_directory
	stow shells_common_configuration
	stow git
	stow nvim
	stow bash
	# stow tmux
	stow zsh
}

configure_git_ssh_key_pairs() {
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
}

setup_zsh() {
	local antidote_config_directory="$base_config_directory/antidote"

	print_header "Setting up Zsh and Antidote package manger"
	# Clone antidote if necessary
	[[ -e $antidote_config_directory ]] || git clone https://github.com/mattmc3/antidote.git $antidote_config_directory
	# Add zsh as a login shell
	command -v zsh | sudo tee -a /etc/shells
	# Use zsh as default shell
	sudo chsh -s $(which zsh) $USER
}

setup_powerlevel10k() {
	local powerlevel10k_config_directory="$base_config_directory/powerlevel10k"

	print_header "Installing Powerlevel 10k"
	[[ -e $powerlevel10k_config_directory ]] || git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $powerlevel10k_config_directory
}

setup_nvim() {
	print_header "Installing Neovim Plugins"
	# nvim --headless +PlugInstall +qall
}

setup_asdf_version_manager() {
	local asdf_config_directory="$base_config_directory/asdf"

	print_header "Setting up Asdf version manager"
	# Download ASDF
	[[ -e $asdf_config_directory ]] || git clone https://github.com/asdf-vm/asdf.git $asdf_config_directory --branch v0.10.2
	# Import ASDF
	[[ -e $asdf_config_directory/asdf.sh ]] && source $asdf_config_directory/asdf.sh
}

#===============================================================================
# Program
#===============================================================================

install_nix
source_nix
install_nix_packages
stow_dotfiles
configure_git_ssh_key_pairs
setup_zsh
setup_nvim
setup_asdf_version_manager
reload_shell

#===============================================================================
# TODO's
#===============================================================================

# TODO: Remove this in favor of Alacritty
# [[ "$IS_MAC_OS" == "true" ]] && stow kitty

# TODO: Look at how to get npm installed ahead of this so can install
# the following global npm modules
# npm install --global trash-cli