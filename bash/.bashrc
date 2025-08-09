# ~/.bashrc

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
