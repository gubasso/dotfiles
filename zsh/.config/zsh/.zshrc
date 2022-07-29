# .zshrc
. $ZDOTDIR/zsh-functions

PROMPT="%1~ > "

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

export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# # Colors
# autoload -Uz colors && colors

# zstyle ':completion:*' menu select
# zstyle ':completion:*' rehash true

# () {
#   emulate -L zsh
#   local -r cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
#   autoload -Uz _store_cache compinit
#   zstyle ':completion:*' use-cache true
#   zstyle ':completion:*' cache-path $cache_dir/.zcompcache
#   [[ -f $cache_dir/.zcompcache/.make-cache-dir ]] || _store_cache .make-cache-dir
#   compinit -C -d $cache_dir/.zcompdump
# }

# autoload -U compinit && compinit
# local zcompdumpdir="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
# [ ! -d "${zcompdumpdir}" ] && mkdir -p ${zcompdumpdir}
# compinit -d ${zcompdumpdir}
# zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
# Install plugins if there are plugins that have not been installed

eval "$(starship init zsh)"

