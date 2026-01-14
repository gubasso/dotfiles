function __python_project_setup --description 'If cwd is a python project, run mise activation and venv activation as applicable'
    if not __is_python_project
        __log_info "Not a Python project; skipping Python setup."
        return 0
    end

    __log_info "Detected Python project; running setup..."

    # Deactivate any existing virtualenv to ensure project-local env
    if set -q VIRTUAL_ENV
        __log_info "Deactivating existing virtualenv:" $VIRTUAL_ENV
        if functions -q deactivate
            deactivate
        else
            # Restore PATH before clearing venv variables
            if set -q _OLD_VIRTUAL_PATH
                set -gx PATH $_OLD_VIRTUAL_PATH
            end
            set -e VIRTUAL_ENV
            set -e _OLD_VIRTUAL_PATH
        end
    end

    # Step 1: Mise setup (if applicable)
    if test -f mise.toml
        __mise_activate; or return  # Hard error - respect pinned version
    else if test -f pyproject.toml
        __mise_python_setup
        # Note: may fail silently (e.g., no tomlq) - OK, we check python3 below
    else if test -f .python-version -o -f .tool-versions
        # Mise reads these natively
        __mise_activate
    end

    # Verify python3 is available before venv operations
    if not type -q python3
        __log_err "python3 not found on PATH"
        return 1
    end

    # Step 2: Poetry activation (handles non-poetry gracefully)
    # Don't abort on failure - fall through to .venv
    __poetry_activate

    # Step 3: Fallback to .venv if no virtualenv active
    if not set -q VIRTUAL_ENV
        __venv_activate; or return
    end

    __log_info "Python project setup complete."
    return 0
end
