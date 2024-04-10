#!/bin/sh

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	exec startx
fi
. "$HOME/.cargo/env"

export PATH="/home/gubasso/.local/share/solana/install/active_release/bin:$PATH"
