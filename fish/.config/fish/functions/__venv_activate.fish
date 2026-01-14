function __venv_activate --description 'Create .venv if needed and activate it'
    __require python; or return

    if not test -d .venv
        __log_info "Creating .venv with python -m venv..."
        python -m venv .venv
        if test $status -ne 0
            __log_err "Failed to create .venv with python -m venv"
            return 1
        end
        __log_info "Created .venv successfully."
    end

    if not test -f .venv/bin/activate.fish
        __log_err ".venv/bin/activate.fish not found"
        return 1
    end

    source .venv/bin/activate.fish
    if test $status -ne 0
        __log_err "Failed to source .venv/bin/activate.fish"
        return 1
    end

    if not set -q VIRTUAL_ENV
        __log_err "Virtual environment does not appear active (VIRTUAL_ENV is not set)."
        return 1
    end

    __log_info "Activated .venv virtualenv:" $VIRTUAL_ENV
    return 0
end
