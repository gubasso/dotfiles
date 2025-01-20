aliases_dir="$HOME/.config/shell/aliases"
source "$aliases_dir"/common.sh

hostname=$(uname -n)

case "$hostname" in
  valinor)
    source "$aliases_dir"/valinor.sh
    ;;
  tumblesuse)
    source "$aliases_dir"/tumblesuse.sh
    ;;
esac
