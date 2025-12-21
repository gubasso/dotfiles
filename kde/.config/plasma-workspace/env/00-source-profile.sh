#!/bin/sh
# This file is sourced by Plasma (do NOT use `exit` here).

[ -n "${PLASMA_PROFILE_SOURCED:-}" ] && return 0
export PLASMA_PROFILE_SOURCED=1

[ -r "$HOME/.profile" ] && . "$HOME/.profile"
