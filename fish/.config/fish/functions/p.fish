function p --description 'FZF-select a git project under ~/Projects; set kitty tab title; run python setup (mise/poetry) when applicable'
    __require fzf z; or return

    set -l projects_dir ~/Projects
    if not test -d $projects_dir
        __log_err "Projects directory not found:" $projects_dir
        return 1
    end

    if not functions -q __kitty_set_tab_title
        __log_err "__kitty_set_tab_title function not found in this Fish session."
        return 1
    end

    set -l proj_dirs (__find_git_projects $projects_dir)
    if test $status -ne 0
        return 1
    end

    # Build fzf query from arguments (if any)
    set -l fzf_query ""
    if test (count $argv) -gt 0
        set fzf_query (string join " " -- $argv)
    end

    # Show relative paths in fzf; selection returns relative path.
    set -l fzf_args --prompt="Project> " --height=40% --reverse --border \
                    --preview="ls -la \"$projects_dir/{}\" 2>/dev/null | sed -n '1,200p'"

    if test -n "$fzf_query"
        set -a fzf_args --query="$fzf_query"
    end

    set -l selected_rel (
        printf "%s\n" $proj_dirs \
        | string replace -r "^"(string escape --style=regex -- $projects_dir)"/" "" \
        | fzf $fzf_args
    )

    if test $status -ne 0
        __log_err "fzf selection cancelled or failed."
        return 1
    end
    if test -z "$selected_rel"
        __log_err "No selection made."
        return 1
    end

    set -l selected_dir "$projects_dir/$selected_rel"
    if not test -d "$selected_dir"
        __log_err "Selected directory no longer exists:" $selected_dir
        return 1
    end

    z "$selected_dir"
    if test $status -ne 0
        __log_err "Failed to cd into:" $selected_dir
        return 1
    end
    __log_info "Changed directory to:" $selected_dir

    set -l proj_name (path basename -- "$selected_dir")
    __kitty_set_tab_title "P: $proj_name"
    if test $status -ne 0
        __log_err "Failed to set kitty tab title via __kitty_set_tab_title."
        return 1
    end
    __log_info "Set Kitty tab title to:" "P: $proj_name"

    __python_project_setup; or return

    __log_info "Project '$proj_name' ready."
end
