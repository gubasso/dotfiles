function __find_git_projects --description 'Find all git project root directories under a given path'
    set -l search_dir $argv[1]

    if test -z "$search_dir"
        __err_exit "__find_git_projects: No search directory provided."
        return 1
    end

    if not test -d "$search_dir"
        __err_exit "__find_git_projects: Directory not found:" $search_dir
        return 1
    end

    __require fd; or return

    set -l git_dirs (fd --hidden --no-ignore --absolute-path --type d '^\.git$' $search_dir 2>/dev/null)
    if test $status -ne 0
        __err_exit "fd failed while scanning for .git directories."
        return 1
    end
    if test (count $git_dirs) -eq 0
        __err_exit "No git repositories found under:" $search_dir
        return 1
    end

    # Convert ".../.git" -> project root dir, dedupe + sort.
    set -l proj_dirs
    for g in $git_dirs
        set -l root (path dirname -- $g)
        if test -d $root
            set -a proj_dirs $root
        end
    end

    if test (count $proj_dirs) -eq 0
        __err_exit "No valid project roots derived from .git directories."
        return 1
    end

    printf "%s\n" $proj_dirs | sort -u
end
