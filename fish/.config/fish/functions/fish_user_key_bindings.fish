function fish_user_key_bindings
  # bind Space+y in visual mode:
  #  \x20 is “space”
  #  --mode visual      → only active in visual mode
  #  --sets-mode default→ switch back to normal mode when done
  bind --mode visual --sets-mode default \x20y \
      'fish_clipboard_copy; commandline -f repaint-mode; commandline -f end-selection'

  # Ctrl-P  → previous history match (up-or-search)
  bind -M insert \cp up-or-search
  # Ctrl-N  → next history match (down-or-search)
  bind -M insert \cn down-or-search
  # Ctrl-f or Ctrl-o  → accept autosuggestion
  bind -M insert \cf accept-autosuggestion
  bind -M insert \co accept-autosuggestion
end
