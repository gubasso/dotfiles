function __python_project_setup --description 'If cwd is a python project, run mise activation and venv activation as applicable'
    if not __is_python_project
        __info "Not a Python project; skipping Python setup."
        return 0
    end

    __info "Detected Python project; running setup..."
    __maybe_mise_activate; or return
    __poetry_activate; or return

    # If no virtual environment is active after Poetry attempt, create/activate .venv
    if not set -q VIRTUAL_ENV
        __venv_activate; or return
    end

    __info "Python project setup complete."
    return 0
end
