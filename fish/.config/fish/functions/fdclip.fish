function fdclip --description 'Find files with fd, copy contents to clipboard' --wraps fd
    # Dependencies
    for cmd in fd bat clip
        if not type -q $cmd
            echo "Error: '$cmd' is required but not found." >&2
            return 127
        end
    end

    # Optional defaults
    set -l defaults -E .git

    # Collect results (NUL-safe)
    set -l files
    command fd -0 $defaults $argv | while read -lz p
        set files $files $p
    end
    # exit code of fd from the pipeline above
    set -l status_fd $pipestatus[1]
    if test $status_fd -ne 0
        return $status_fd
    end
    if test (count $files) -eq 0
        echo "fdclip: no matches."
        return 1
    end

    # Copy concatenated contents to clipboard
    command bat --paging=never --decorations=always -- $files | clip
    # If bat or clip failed, propagate that error
    for s in $pipestatus
        if test $s -ne 0
            return $s
        end
    end

    # Finally, print the fd output (one path per line)
    printf '%s\n' $files
end

# Inherit fd’s completions
complete -c fdclip -w fd
