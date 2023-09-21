zmodload zsh/zprof
autoload -Uz colors && colors

export ZCOMPDUMP_FILE="${XDG_CACHE_HOME}/zsh/zcompdump"
export ZPLUGINS_DIR="${XDG_CACHE_HOME}/zsh/plugins"
export FUNCTIONS_DIR="${XDG_CONFIG_HOME}/zsh/zfunc"
fpath+="${FUNCTIONS_DIR}"
# Basic auto/tab complete:
# optimizing compinit loading time: https://medium.com/@dannysmith/little-thing-2-speeding-up-zsh-f1860390f92
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
for dump in $ZCOMPDUMP_FILE(N.mh+24); do
    compinit -d $ZCOMPDUMP_FILE
done
compinit -d $ZCOMPDUMP_FILE -C
# compinit -d $ZCOMPDUMP_FILE
_comp_options+=(globdots)		# Include hidden files.
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# .zshrc
. $ZDOTDIR/zsh-functions
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "MichaelAquilina/zsh-you-should-use"
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=ALL

. $XDG_CONFIG_HOME/.shell_alias
. $XDG_CONFIG_HOME/.shell_env_vars

# asdf
source /opt/asdf-vm/asdf.sh

#######
# Fzf #
#######
# References:
# [^fzf1]: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# sources
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

eval "$(starship init zsh)"
# PROMPT="%1~ > "
