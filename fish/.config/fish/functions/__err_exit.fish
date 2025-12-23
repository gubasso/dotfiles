function __err_exit --description 'Print an error message to stderr and return non-zero'
    if test (count $argv) -eq 0
        printf "ERROR\n" >&2
    else
        printf "ERROR: %s\n" (string join " " -- $argv) >&2
    end
    return 1
end
