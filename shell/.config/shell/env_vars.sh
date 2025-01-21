env_vars_dir="$HOME/.config/shell/env_vars"
source "$env_vars_dir"/common.sh

hostname=$(uname -n)

case "$hostname" in
  valinor)
    source "$env_vars_dir"/valinor.sh
    ;;
  tumblesuse)
    source "$env_vars_dir"/tumblesuse.sh
    ;;
esac
