function __venv_activate --description 'Create .venv if needed and activate it'
    __require python; or return

    if not test -d .venv
        printf "INFO: Creating .venv with python -m venv\n" >&2
        python -m venv .venv
        if test $status -ne 0
            __err_exit "Failed to create .venv with python -m venv"
            return 1
        end
    end

    if not test -f .venv/bin/activate.fish
        __err_exit ".venv/bin/activate.fish not found"
        return 1
    end

    source .venv/bin/activate.fish
    if test $status -ne 0
        __err_exit "Failed to source .venv/bin/activate.fish"
        return 1
    end

    if not set -q VIRTUAL_ENV
        __err_exit "Virtual environment does not appear active (VIRTUAL_ENV is not set)."
        return 1
    end

    return 0
end
