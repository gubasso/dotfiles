#########################
# Environment Variables #
#########################

export ENV_DIR="$XDG_CONFIG_HOME/env.d"

source "$ENV_DIR"/general.sh

hostname=$(uname -n)
case "$hostname" in
  valinor)
    source "$ENV_DIR"/host-valinor.sh
    ;;
  tumblesuse)
    source "$ENV_DIR"/host-tumblesuse.sh
    ;;
esac
