# ┌─────────────────────────────┐
# │┏━╸╻┏━┓╻ ╻   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸│
# │┣╸ ┃┗━┓┣━┫   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓│
# │╹  ╹┗━┛╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛│
# └─────────────────────────────┘

# --- Header --------------------------------------------
set -g fish_key_bindings fish_vi_key_bindings
set -g host (string split -m1 '.' (uname -n))
set -g cfg_d "$HOME/.config/fish"

# --- Main --------------------------------------------
for f in \
    # ENV
    "$cfg_d/env/public/common.fish" \
    "$cfg_d/env/public/hosts/$host.fish" \
    "$cfg_d/env/private/common.fish" \
    "$cfg_d/env/private/hosts/$host.fish" \
    # ABBREVIATIONS
    "$cfg_d/abbreviations/public/common.fish" \
    "$cfg_d/abbreviations/public/hosts/$host.fish" \
    "$cfg_d/abbreviations/private/common.fish" \
    "$cfg_d/abbreviations/private/hosts/$host.fish"
    # source...
    test -f "$f"; and source "$f"
end

# --- Footer --------------------------------------------
__source_starship
zoxide init fish | source

# --- EOF -----------------------------------------------
