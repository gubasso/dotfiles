function clip --description "Copy text to the system clipboard"
    if type -q xclip
        command xclip -selection clipboard
    else if type -q wl-copy
        command wl-copy
    else
        echo "clip: no clipboard tool found (install wl-clipboard or xclip)" >&2
        return 127
    end
end
