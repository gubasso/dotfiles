function __require --description 'Require one or more commands to exist on PATH'
    if test (count $argv) -eq 0
        __err_exit "__require: no dependencies specified"
        return 1
    end

    set -l missing
    for cmd in $argv
        if not type -q $cmd
            set -a missing $cmd
        end
    end

    if test (count $missing) -gt 0
        __err_exit "Missing dependencies:" (string join ", " -- $missing)
        return 1
    end

    return 0
end
