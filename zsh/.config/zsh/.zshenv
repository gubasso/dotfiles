# echo "$ZDOTDIR/.zshenv"
# $ZDOTDIR was loaded at /etc/zsh/zshenv
# $HOME is available here

# My config
## XDG + PATH env vars
. /etc/shell/env.sh
. "$XDG_CONFIG_HOME/env.d/main.sh"

export ZCOMPDUMP_FILE="${XDG_CACHE_HOME}/zsh/zcompdump"

# zinit light MichaelAquilina/zsh-you-should-use
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=ALL

#################
# Others config
# . "$XDG_DATA_HOME/dfx/env"
