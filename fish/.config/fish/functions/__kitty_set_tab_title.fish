function __kitty_set_tab_title --description 'Set kitty tab title when running inside kitty'
    set -l title $argv[1]

    # Only do anything if we are inside kitty
    if test -n "$KITTY_WINDOW_ID"
        # Use kitty remote control to set the tab title
        command kitten @ set-tab-title "$title" 2>/dev/null
    end
end

