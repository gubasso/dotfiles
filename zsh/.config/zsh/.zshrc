# archwiki: Used for setting user's interactive shell configuration and executing commands, will be read when starting as an interactive shell

# zinit plugin manager, installed from AUR
source /usr/share/zinit/zinit.zsh
## zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
## zinit Oh-my-zsh snippets/plugins
## https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
# zinit replay cache completions
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# fzf
## Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# History in cache directory:
HISTSIZE=5000
SAVEHIST=$HISTSIZE
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTDUP=erase
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space


# Change cursor shape for different vi modes.
## https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
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

# Keybindings
## vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1
## Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
## History search just for the command already typed in shell
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# keychain
eval $(keychain --nogui --quiet --noask --eval --agents ssh,gpg \
  cwntroot-ed25519 \
  gubasso-android-ed25519 \
  gubasso-ed25519 \
  id_rsa \
  sysking-eambar-ed25519 \
  gubasso@eambar.net \
  gubasso@cwnt.io)

# end of .zshrc
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/zen.toml)"
# ---
