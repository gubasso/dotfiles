#!/bin/sh
# archwiki: Used for executing user's commands at start, will be read when starting as a login shell
# Typically used to:
#   - autostart graphical sessions
#   - set session-wide environment variables

# archwiki zsh: session-wide environment variables
. "$XDG_CONFIG_HOME/shell_alias"
. "$XDG_CONFIG_HOME/shell_env_vars"

# auto run exec startx after login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	exec startx
fi
