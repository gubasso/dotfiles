# PATH
set -l custom_paths \
  "$HOME/.local/bin" \
  "$HOME/.local/bin/private" \
  "$HOME/.cargo/bin" \
  "$HOME/.npm-global/bin"

set -x PATH $custom_paths $PATH

# GENERAL
set -x VISUAL      nvim
set -x EDITOR      nvim
set -x SUDO_EDITOR $EDITOR
set -x TERMINAL    wezterm

# APPS
set -x EZA_COLORS "\
ur=0:uw=0:ux=0:ue=0:\
gr=0:gw=0:gx=0:\
tr=0:tw=0:tx=0:\
sn=0:sb=0:\
uu=0:un=0"
