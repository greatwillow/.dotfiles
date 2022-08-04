BASE_CONFIG_DIRECTORY="$HOME/.config"
SHELLS_COMMON_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/sh"
SHELL_ALIASES_DIRECTORY="$SHELLS_COMMON_CONFIG_DIRECTORY/.aliases"
ZSH_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/zsh"
ZSH_PLUGINS_DIRECTORY="$ZSH_CONFIG_DIRECTORY/plugins"
ZSH_PLUGINS_CONFIG_PATH="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.sh"
ANTIDOTE_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/antidote"
NIX_SHELL_CONFIG_PATH="~/.nix-profile/etc/profile.d/nix.sh"
ASDF_CONFIG_DIRECTORY="$HOME/.config/asdf"
ASDF_SHELL_CONFIG_PATH="$ASDF_CONFIG_DIRECTORY/asdf.sh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# clone antidote if necessary
[[ -e $ANTIDOTE_CONFIG_DIRECTORY ]] || git clone https://github.com/mattmc3/antidote.git $ANTIDOTE_CONFIG_DIRECTORY
# source antidote
source $ANTIDOTE_CONFIG_DIRECTORY/antidote.zsh
# generate and source plugins from $ZSH_CONFIG_DIRECTORY/.zsh_plugins.txt
antidote load $ZSH_PLUGINS_CONFIG_PATH

# Zsh History Settings
setopt HIST_IGNORE_ALL_DUPS # History won't save duplicates.
setopt HIST_FIND_NO_DUPS # History won't show duplicates on search.

# Import Plugins
source [[ -f $ZSH_PLUGINS_DIRECTORY ]] && source $ZSH_PLUGINS_DIRECTORY
# Import Aliases
source [[ -f $SHELL_ALIASES_DIRECTORY ]] && source $SHELL_ALIASES_DIRECTORY

# Import ASDF
[[ -e $ASDF_SHELL_CONFIG_PATH ]] && source $ASDF_SHELL_CONFIG_PATH

# Import Nix
[[ -e $NIX_SHELL_CONFIG_PATH ]] && source $NIX_SHELL_CONFIG_PATH

# Import PowerLevel10k -> To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Completions
fpath=(${ASDF_DIR}/completions $fpath)  # Adds ASDF completions to PATH
autoload -U compinit; compinit	# Activates completions