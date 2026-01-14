function __log_info --description 'Print an info message to stderr'
    if test (count $argv) -eq 0
        return 0
    end
    printf "INFO: %s\n" (string join " " -- $argv) >&2
end
