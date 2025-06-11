# wezvim: cd into $1, tell WezTerm about it, then open nvim
wezvim() {
  local open_nvim=false
  local dir

  if [[ $1 == -e || $1 == --edit ]]; then
    open_nvim=true
    shift
  fi

  if [[ -z $1 ]]; then
    echo "Usage: wezvim [-e|--edit] <directory>" >&2
    return 1
  fi
  dir=$1

  if [[ ! -d $dir ]]; then
    echo "⛔ Directory not found: $dir" >&2
    return 1
  fi

  cd -- "$dir" || return

  if $open_nvim; then
    # notify WezTerm of the new cwd (so e.g. cmd-click in the title bar works)
    if command -v wezterm &>/dev/null; then
      wezterm set-working-directory "$PWD"
    else
      # fallback to raw OSC-7 if wezterm CLI isn't available
      printf '\033]7;file://%s%s\033\\' "$(hostname)" "$PWD"
    fi
    nvim
  fi
}

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
