ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# echo "$ZDOTDIR/.zshrc"
# [Profiling zsh setup with zprof](https://www.dotruby.com/tapas/profiling-zsh-setup-with-zprof)
# [Profiling zsh startup time](https://stevenvanbael.com/profiling-zsh-startup)
# cmd to profile:
# time ZSH_DEBUGRC=1 zsh -i -c exit
# just the time:
# time zsh -i -c exit
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi

# plugins
zinit lucid wait light-mode for \
  Aloxaf/fzf-tab \
  MichaelAquilina/zsh-you-should-use \
  MichaelAquilina/zsh-auto-notify
# MichaelAquilina/zsh-auto-notify
export AUTO_NOTIFY_WHITELIST=("paru" "pacman" "up" "npm install")

zinit lucid wait for \
  OMZP::command-not-found

# zinit pack for ls_colors

# completions should be the last [^1]
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zsh-users/zsh-syntax-highlighting \
      OMZP::colored-man-pages \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-completions
# zinit light nyquase/vi-mode
# zinit light b4b4r07/zsh-vimode-visual
# zinit light jeffreytse/zsh-vi-mode
## zinit Oh-my-zsh snippets/plugins
## https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
# # Load completions
# autoload -Uz compinit && compinit
# # zinit replay cache completions
# zinit cdreplay -q

#---------------- Completion styling ------------------------------------------
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#

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
## History search just for the command already typed in shell
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Opens command in $EDITOR [^2][^3]
autoload -U edit-command-line; zle -N edit-command-line
## ESC (normal mode) + v (opens vim)
bindkey -v
bindkey -M vicmd v edit-command-line

# keychain
# export GPG_AGENT_INFO="~/.gnupg/S.gpg-agent:$(pgrep gpg-agent):1"
# eval $(keychain --nogui --quiet --noask --eval --agents ssh,gpg \
#   cwntroot-ed25519 \
#   gubasso-android-ed25519 \
#   gubasso-ed25519 \
#   id_rsa \
#   sysking-eambar-ed25519 \
#   gubasso@eambar.net \
#   gubasso@cwnt.io)

# Alias ---------------------------------------
. "$XDG_CONFIG_HOME/shell/aliases.sh"

function src() {
  source "$ZDOTDIR/.zshenv"
  source "$ZDOTDIR/.zshrc"
}

## zsh specific aliases
alias mise_activate='eval "$(mise activate zsh)"'


# end of .zshrc
# eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/zen.toml)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
# ---
# Profiling
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zprof
fi

# References:
# [^1]: https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#calling-compinit-with-turbo-mode "Calling compinit With Turbo Mode"
# [^2]: https://unix.stackexchange.com/questions/6620/how-to-edit-command-line-in-full-screen-editor-in-zsh "How to edit command line in full screen editor in ZSH?"
# [^3]: https://apple.stackexchange.com/questions/88515/how-do-i-edit-current-shell-command-in-vi "How do I edit current shell command in VI"
### End of Zinit's installer chunk
