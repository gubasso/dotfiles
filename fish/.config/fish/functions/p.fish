function p --description 'FZF-select a git project under ~/Projects; set kitty tab title; run python setup (mise/poetry) when applicable'
    __require fzf z; or return

    set -l projects_dir ~/Projects
    if not test -d $projects_dir
        __err_exit "Projects directory not found:" $projects_dir
        return 1
    end

    if not functions -q __kitty_set_tab_title
        __err_exit "__kitty_set_tab_title function not found in this Fish session."
        return 1
    end

    set -l proj_dirs (__find_git_projects $projects_dir)
    if test $status -ne 0
        return 1
    end

    # Show relative paths in fzf; selection returns relative path.
    set -l selected_rel (
        printf "%s\n" $proj_dirs \
        | string replace -r "^"(string escape --style=regex -- $projects_dir)"/" "" \
        | fzf --prompt="Project> " --height=40% --reverse --border \
              --preview="ls -la \"$projects_dir/{}\" 2>/dev/null | sed -n '1,200p'"
    )

    if test $status -ne 0
        __err_exit "fzf selection cancelled or failed."
        return 1
    end
    if test -z "$selected_rel"
        __err_exit "No selection made."
        return 1
    end

    set -l selected_dir "$projects_dir/$selected_rel"
    if not test -d "$selected_dir"
        __err_exit "Selected directory no longer exists:" $selected_dir
        return 1
    end

    z "$selected_dir"
    if test $status -ne 0
        __err_exit "Failed to cd into:" $selected_dir
        return 1
    end

    set -l proj_name (path basename -- "$selected_dir")
    __kitty_set_tab_title "P: $proj_name"
    if test $status -ne 0
        __err_exit "Failed to set kitty tab title via __kitty_set_tab_title."
        return 1
    end

    __python_project_setup; or return
end
