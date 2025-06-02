
# Usage: require_cmds <cmd> [<cmd> ...]
# Exits with an error if any listed command is missing.
require_cmds() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done

  if ((${#missing[@]})); then
    printf '❌ ERROR: the following required commands are missing: %s\n' "${missing[*]}"
    exit 1
  fi
}

get_dir() {
  local dir="$1"

  [[ -d $dir ]] ||
    { echo "❌ ERROR: Path '$dir' does not exist or is not a directory."; exit 1; }

    echo "$dir"
}
