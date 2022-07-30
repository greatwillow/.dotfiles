# The following sources ~/.bashrc in the interactive login case,
# because .bashrc isn't sourced for interactive login shells
# Pull in .bashrc file configuration
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi