###########
# Aliases #
###########

source "$ALIASES_DIR/general.sh"

hostname=$(uname -n)
case "$hostname" in
  valinor)
    source "$ALIASES_DIR/host-valinor.sh"
    ;;
  tumblesuse)
    source "$ALIASES_DIR/host-tumblesuse.sh"
    ;;
esac

source "$ALIASES_DIR_PRIVATE/main.sh"
