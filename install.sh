# Inspired originally by the following setup by Jake Weis 
# See: https://github.com/jakewies/.dotfiles
# With instructions here: https://www.youtube.com/watch?v=70YMTHAZyy4&list=PL1C97G3GhlHdANMFUIXTcFr14R7b7EBj9&index=1

ZSH_CONFIG_DIRECTORY="~/.config/zsh"
ZSH_PLUGINS_DIRECTORY="$ZSH_CONFIG_DIRECTORY/plugins"
ZSH_PLUGINS_TEXT_FILE="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.txt"
ZSH_PLUGINS_FILE="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.sh"
SHELLS_COMMON_CONFIG_DIRECTORY="$HOME/.config/sh"
EXPORTS_FILE="$SHELLS_COMMON_CONFIG_DIRECTORY/.exports"
NIX_SHELL_CONFIG_PATH="~/.nix-profile/etc/profile.d/nix.sh"

# Import Exports to be able check platform os type
source [[ -f $EXPORTS_FILE ]] && source $EXPORTS_FILE

# ----------------------------------------- Nix -------------------------------------
echo "----------------------------> Installing Nix"
curl -L https://nixos.org/nix/install | sh

echo "----------------------------> Sourcing Nix"
source $NIX_SHELL_CONFIG_PATH

echo "----------------------------> Installing Nix Packages"
nix-env -iA \
	nixpkgs.zsh \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.stow \
	nixpkgs.yarn \
	nixpkgs.fzf \
	nixpkgs.ripgrep \
	nixpkgs.bat

	# ---- Direnv ----
	# allows for localized env variables
	# See -> https://shivamarora.medium.com/a-guide-to-manage-your-environment-variables-in-a-better-way-using-direnv-2c1cd475c8e
	# Also See -> https://www.youtube.com/watch?v=YkxoGRpHcVQ
	# nixpkgs.direnv
	# ---- GnuMake ----
	# nixpkgs.gnumake \
	# ---- Tmux ----
	# nixpkgs.tmux \
	# ---- Gnu Compiler Collection ----
	# Used to compile different languages
	# nixpkgs.gcc \

# ----------------------------------------- Stow -------------------------------------
echo "----------------------------> Stowing dotfiles"
stow shells_common_configuration
stow git
stow nvim
# stow tmux
stow zsh

# ----------------------------------------- Stow -------------------------------------
echo "----------------------------> Setting up Github SSH key pairs."
echo "Please enter your github email."
read github_email
ssh-keygen -t rsa -b 4096 -C $github_email

echo "----------------------------> Starting ssh-agent in the background."
eval "$(ssh-agent -s)"

echo "----------------------------> Adding your SSH key to ssh-agent."
ssh-add ~/.ssh/id_rsa

echo "----------------------------> Copying SSH key to your clipboard."
pbcopy < ~/.ssh/id_rsa.pub

echo "----------------------------> Add key to github to finish setup."
echo "Press enter to open instructions."
read throwaway_input
open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
open https://github.com/settings/keys

# ----------------------------------------- Zsh -------------------------------------
echo "----------------------------> Setting up Zsh and Antidote package manger"
# Clone antidote if necessary
[[ -e ~/.config/antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.config/antidote
# Add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells
# Use zsh as default shell
sudo chsh -s $(which zsh) $USER

# ----------------------------------------- Nvim -------------------------------------
echo "----------------------------> Installing Neovim Plugins"
# nvim --headless +PlugInstall +qall

# ----------------------------------------- ASDF -------------------------------------
echo "----------------------------> Setting up Asdf version manager"
# Download ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.config/asdf --branch v0.10.2
# Import ASDF
[[ -e $ASDF_SHELL_CONFIG_PATH ]] && source $ASDF_SHELL_CONFIG_PATH

# ----------------------------------------- TODO -------------------------------------
# TODO: Remove this in favor of Alacritty
# [[ "$IS_MAC_OS" == "true" ]] && stow kitty

# TODO: Look at how to get npm installed ahead of this so can install
# the following global npm modules
# npm install --global trash-cli