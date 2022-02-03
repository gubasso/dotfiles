#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# https://catonmat.net/bash-vi-editing-mode-cheat-sheet
set -o vi

###########
# Aliases #
###########
# References:
# [^al1]: https://www.homeonrails.com/2016/05/truecolor-in-gnome-terminal-tmux-and-neovim/
# [^al2]: My notes, Dotfiles
# [^al3]: [Clear a terminal screen for real: KDE](https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real)
# [^al4]: `cat file | xclip -selection clipboard` [How can I copy the output of a command directly into my clipboard?](https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#5130969)
alias ls='exa'
alias tree='exa --tree --all --git-ignore --ignore-glob ".git"'
alias cat='bat'
alias rg='rg --hidden --smart-case'
alias tmux="env TERM=xterm-256color tmux" # [^al1]
alias trash='trash-put'
alias cl='clear'
alias clrm='clear && echo -en "\e[3J"' #[^al3]
alias cf='cd ${HOME} && `__fzf_cd__`' #change dir with fuzzy
alias ga='git add . && git commit'
alias gam='git add . && git commit -m'
alias ss='sudo systemctl'
alias toxclip='xclip -selection clipboard' #[^al4]

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
# variables
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git' #[^fzf1]
export FZF_DEFAULT_OPTS='--no-height --layout=reverse --inline-info' #[^fzf1]
export FZF_TMUX=1 #[^fzf1]
# CTRL_T
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # To apply the command to CTRL-T as well[^fzf1]
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'" # Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)[^fzf1]
# ALT_C
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
# CTRL_R
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'" # Full command on preview window, `?` key for toggling the preview window[^fzf1]


#########################
# Environment Variables #
#########################
export VISUAL=nvim
export EDITOR=nvim
# Add my personal binaries to the PATH
export PATH="${PATH}:/home/gubasso/Bin"
export PATH="${PATH}:/home/gubasso/.local/bin"

# Add ASDF to PATH/Shell and completions
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

###############
# Exercism.io #
###############
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
    source ~/.config/exercism/exercism_completion.bash
fi
