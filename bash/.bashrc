# ~/.bashrc

. $XDG_CONFIG_HOME/.shell_alias
. $XDG_CONFIG_HOME/.shell_env_vars

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# https://catonmat.net/bash-vi-editing-mode-cheat-sheet
set -o vi

# PS1='[\u@\h \W]\$ '
export PS1="\W > "

#######
# Fzf #
#######
# References:
# [^fzf1]: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# sources
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
# usage: _fzf_setup_completion path|dir|var|alias|host COMMANDS...
# https://github.com/junegunn/fzf#supported-commands
_fzf_setup_completion dir gocryptfs

# asdf
. /opt/asdf-vm/asdf.sh

. "/home/gubasso/.asdf/asdf.sh"
. "/home/gubasso/.asdf/completions/asdf.bash"
