
aliases_dir="$HOME/.config/shell/aliases"
source "$aliases_dir"/general.sh

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    arch)
      source "$aliases_dir"/arch.sh
      ;;
    opensuse)
      source "$aliases_dir"/opensuse.sh
      ;;
  esac
fi
