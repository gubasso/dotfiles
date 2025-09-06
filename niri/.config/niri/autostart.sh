#!/usr/bin/dash

launch() {
  niri msg action focus-workspace "$1"; shift
  niri msg action spawn -- "$@"
  sleep 0.3
  niri msg action maximize-column
}

launch work kitty
launch notes kitty
niri msg action focus-workspace work
