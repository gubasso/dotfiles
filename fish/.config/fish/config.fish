# ┌─────────────────────────────┐
# │┏━╸╻┏━┓╻ ╻   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸│
# │┣╸ ┃┗━┓┣━┫   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓│
# │╹  ╹┗━┛╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛│
# └─────────────────────────────┘

# --- Header --------------------------------------------
set -g fish_key_bindings fish_vi_key_bindings
set -g cfg_d "$HOME/.config/fish"

# --- Main ----------------------------------------------

# Loading abbreviations...
for f in "$cfg_d"/abbreviations{,-$hostname}{,.priv}.fish
    test -f "$f" && source "$f"
end

fzf --fish | source

# --- Footer --------------------------------------------
__source_starship
zoxide init fish | source

# -------------------------------------------------------
