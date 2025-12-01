function __project_nvim --description 'Set tab title, cd into project dir, open Neovim'
    set -l title $argv[1]
    set -l dir   $argv[2]
    set -l files $argv[3..-1]

    __kitty_set_tab_title "$title"

    if not test -d "$dir"
        echo "Directory not found: $dir" >&2
        return 1
    end

    z "$dir"

    if test (count $files) -gt 0
        nvim $files
    else
        nvim
    end
end

