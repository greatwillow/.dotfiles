#!/bin/sh

# Inspired originally by the following setup by Jake Weis 
# See: https://github.com/jakewies/.dotfiles
# With instructions here: https://www.youtube.com/watch?v=70YMTHAZyy4&list=PL1C97G3GhlHdANMFUIXTcFr14R7b7EBj9&index=1

base_config_directory="$HOME/.config"

#===============================================================================
# Functions
#===============================================================================

source _common_functions

install_nix_packages() {
	print_header "Installing Nix Packages"
	nix-env -iA \
		nixpkgs.nix-flakes,
		nixpkgs.zsh \
		nixpkgs.git \
		nixpkgs.neovim \
		nixpkgs.stow \
		nixpkgs.yarn \
		nixpkgs.fzf \
		nixpkgs.ripgrep \
		nixpkgs.bat \
		nixpkgs.alacritty \
		nixpkgs.zsh-powerlevel10k \
		nixpkgs.meslo-lgs-nf

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
	stow zsh
	stow powerlevel10k
	# stow tmux
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

	print_line ""
	print_line "Manual steps need to be completed here.  Go to the following links to find out more: "
	print_line ""
	print_line "https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/"
	print_line "https://github.com/settings/keys"
	print_line ""
	print_line "Press any key when ready to continue with setup."
	read throwaway_input
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
	# Update zsh plugins
	antidote bundle <$HOME/.config/zsh/plugins/.zsh_plugins.txt >$HOME/.config/zsh/plugins/.zsh_plugins.zsh
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

setup_asdf_tool_version_manager() {
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

install_nix_packages
stow_dotfiles
configure_git_ssh_key_pairs
setup_zsh
setup_nvim
setup_asdf_tool_version_manager
reload_shell

#===============================================================================
# TODO's
#===============================================================================

# TODO: Remove this in favor of Alacritty
# [[ "$IS_MAC_OS" == "true" ]] && stow kitty

# TODO: Look at how to get npm installed ahead of this so can install
# the following global npm modules
# npm install --global trash-cli