set -l custom_paths \
  "$HOME/.local/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.npm-global/bin"

set -x PATH $custom_paths $PATH
