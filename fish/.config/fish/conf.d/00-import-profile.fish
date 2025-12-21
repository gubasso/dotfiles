# ~/.config/fish/conf.d/00-import-profile.fish
#
# Goal: Make ~/.profile the single source of truth for exported environment variables.
#
# Fish cannot "source" ~/.profile directly because ~/.profile is POSIX shell syntax.
# Instead, this script:
#   1) Spawns a POSIX sh that inherits the current environment (fish baseline).
#   2) Captures env "before".
#   3) Sources ~/.profile inside that sh.
#   4) Captures env "after".
#   5) Imports only variables that are new/changed due to ~/.profile.
#
# This runs ONLY when needed:
#   - Only for interactive fish shells.
#   - Only if GBASSO_PROFILE_LOADED is not already present (meaning Plasma/SDDM or a
#     parent shell did not already source ~/.profile for this process tree).

# Non-interactive shells should not do session/env bootstrapping work.
if not status --is-interactive
    exit 0
end

# If ~/.profile was already sourced upstream, do nothing.
if set -q GBASSO_PROFILE_LOADED
    exit 0
end

# Capture env before/after sourcing ~/.profile in POSIX sh (NUL-separated).
# Using `env -0` avoids issues with values containing newlines.
set -l before ( sh -c 'env -0' | string split0 )
set -l after  ( sh -c '. "$HOME/.profile" >/dev/null 2>&1; env -0' | string split0 )

# Index "before" into (key -> value) using parallel arrays.
set -l bkeys
set -l bvals
for kv in $before
    set -l parts (string split -m1 '=' -- $kv)
    set -a bkeys $parts[1]
    set -a bvals $parts[2]
end

# Apply only new/changed vars from "after".
for kv in $after
    set -l parts (string split -m1 '=' -- $kv)
    set -l k $parts[1]
    set -l v $parts[2]

    # Skip volatile/session-owned variables that should not be overridden.
    # - PWD/OLDPWD: session state
    # - SHLVL/_: shell bookkeeping
    # - TERM: set by terminal emulator / pty
    # - XDG_RUNTIME_DIR: per-login-session path
    switch $k
        case PWD OLDPWD SHLVL '_' TERM XDG_RUNTIME_DIR
            continue
    end

    # Import if new or changed relative to the baseline.
    set -l idx (contains --index -- $k $bkeys)
    if test -z "$idx"; or test "$v" != "$bvals[$idx]"
        if test "$k" = PATH
            # Fish stores PATH as a list; convert from colon-separated string.
            set -gx PATH (string split ':' -- $v)
        else
            set -gx $k $v
        end
    end
end

# Mark as loaded for this fish session (and for children of fish).
set -gx GBASSO_PROFILE_LOADED 1
