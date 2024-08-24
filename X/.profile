# echo "$HOME/.profile"
#!/bin/sh
# Sample .profile for SUSE Linux
# rewritten by Christian Steinruecken <cstein@suse.de>
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

# archwiki zsh: session-wide environment variables
. "$XDG_CONFIG_HOME/shell_alias"
. "$XDG_CONFIG_HOME/shell_env_vars"

. "$HOME/.cargo/env"
# . "$XDG_DATA_HOME/dfx/env"

