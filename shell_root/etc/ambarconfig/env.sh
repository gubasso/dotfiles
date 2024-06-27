# echo "/etc/ambarconfig/env.sh"
# https://wiki.archlinux.org/title/Environment_variables#Globally
# Export environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
