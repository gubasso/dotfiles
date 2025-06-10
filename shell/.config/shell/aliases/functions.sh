function now() {
  date "+%Y-%m-%d %H:%M:%S" | tr -d '\n' | tee >(clip)
}

function slug() {
  slugify --separator _ "${@}" | tr -d '\n' | tee >(clip)
}

# gitignore generator
gi() {
  if [[ -z $1 ]]; then
    echo "Usage: gi <language>" >&2
    return 1
  fi
  curl -sL "https://www.toptal.com/developers/gitignore/api/${1}"
}
