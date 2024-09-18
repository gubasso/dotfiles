# echo "$ZDOTDIR/.zshenv"
# $ZDOTDIR was loaded at /etc/zsh/zshenv
# $HOME is available here

# My config
## XDG + PATH env vars
. /etc/ambarconfig/env.sh

export ZCOMPDUMP_FILE="${XDG_CACHE_HOME}/zsh/zcompdump"

# zinit light MichaelAquilina/zsh-you-should-use
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=ALL

# work
alias mise_activate='eval "$(mise activate zsh)"'

# zsh config and env vars
# 1) etc/zsh/zshenv: First zsh file to load
# 2) $ZDOTDIR/.zshenv: Second zsh file to load
#   2.1) /etc/ambarconfig/env.sh
# 3) $ZDOTDIR/.zprofile
#   3.1) ~/.profile
#     3.1.1) $XDG_CONFIG_HOME/shell_alias
#     3.1.2) $XDG_CONFIG_HOME/shell_env_vars
# 4) $ZDOTDIR/.zshrc
function src() {
  source "$ZDOTDIR/.zshenv"
  source "$ZDOTDIR/.zprofile"
  source "$ZDOTDIR/.zshrc"
}

#################
# Others config
