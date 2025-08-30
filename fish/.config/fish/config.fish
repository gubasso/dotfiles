# ┌─────────────────────────────┐
# │┏━╸╻┏━┓╻ ╻   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸│
# │┣╸ ┃┗━┓┣━┫   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓│
# │╹  ╹┗━┛╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛│
# └─────────────────────────────┘

# --- Header --------------------------------------------
set -g fish_key_bindings fish_vi_key_bindings
set -g cfg_d "$HOME/.config/fish"

# --- Main ----------------------------------------------

# Loading aliases...
for f in "$cfg_d"/aliases{,-$hostname}{,.priv}.fish
    test -f "$f" && source "$f"
end

# Loading abbreviations...
for f in "$cfg_d"/abbreviations{,-$hostname}{,.priv}.fish
    test -f "$f" && source "$f"
end

# --- Footer --------------------------------------------
__source_starship
zoxide init fish | source

# -------------------------------------------------------
