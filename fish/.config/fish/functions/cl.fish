function cl --description 'Clear screen + Kitty scrollback'
    printf '\e[3J'   # E3: clear scrollback in Kitty
    command clear    # then clear the screen
end
