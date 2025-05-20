aliases_dir="$HOME/.config/shell/aliases"
suse_aliases_dir="$HOME/.config/suse-shell/aliases"
source "$aliases_dir"/common.sh

hostname=$(uname -n)

case "$hostname" in
  valinor)
    source "$aliases_dir"/valinor.sh
    ;;
  tumblesuse)
    source "$aliases_dir"/tumblesuse.sh
    source "$suse_aliases_dir"/tumblesuse-private.sh
    ;;
esac
