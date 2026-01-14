function __log_err --description 'Print an error message to stderr'
    if test (count $argv) -eq 0
        printf "ERROR\n" >&2
    else
        printf "ERROR: %s\n" (string join " " -- $argv) >&2
    end
end
