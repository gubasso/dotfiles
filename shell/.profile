path_prepend() {
  case ":$PATH:" in
    *":$1:"*) : ;;
    *) PATH="$1:$PATH" ;;
  esac
}

if [ "${HOSTNAME:-}" = "tumblesuse" ]; then
  if [ -z "${PROFILEREAD:-}" ] && [ -r /etc/profile ]; then
    . /etc/profile
  fi
fi

for d in \
  "$HOME/.local/bin" \
  "$HOME/.local/npm/bin" \
  "$HOME/.cargo/bin" \
  ; do
  [ -d "$d" ] && path_prepend "$d"
done
export PATH

export TERMINAL=kitty
export EDITOR=nvim
export VISUAL=$EDITOR
export SUDO_EDITOR=$EDITOR
