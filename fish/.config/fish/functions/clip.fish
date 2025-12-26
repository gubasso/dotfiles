function clip --description 'Copy stdin to clipboard (Wayland -> X11 -> OSC 52 fallback)'
    # Require piped stdin (avoid blocking on interactive use)
    if isatty stdin
        echo "clip: expects stdin (example: echo hello | clip)" >&2
        return 2
    end

    # Buffer stdin once so we can attempt multiple backends.
    set -l tmp (mktemp)
    cat > "$tmp"

    # ------------------------------
    # 1) Wayland (wl-copy), if usable
    # ------------------------------
    if type -q wl-copy; and set -q XDG_RUNTIME_DIR; and test -d "$XDG_RUNTIME_DIR"
        # Determine Wayland display socket name (default: wayland-0)
        set -l wd "$WAYLAND_DISPLAY"
        if test -z "$wd"
            set wd "wayland-0"
        end

        # Only attempt if the Wayland socket exists (prevents hang/error spam)
        if test -S "$XDG_RUNTIME_DIR/$wd"
            if cat "$tmp" | command wl-copy >/dev/null 2>&1
                rm -f "$tmp"
                return 0
            end
        end
    end

    # ------------------------------
    # 2) X11 (xclip), if usable
    # ------------------------------
    if type -q xclip; and set -q DISPLAY; and test -n "$DISPLAY"
        if cat "$tmp" | command xclip -selection clipboard >/dev/null 2>&1
            rm -f "$tmp"
            return 0
        end
    end

    # ------------------------------
    # 3) Fallback: OSC 52 (terminal clipboard)
    # ------------------------------
    set -l data (cat "$tmp" | base64 | tr -d '\n')
    rm -f "$tmp"
    printf '\e]52;c;%s\a' "$data"
end
