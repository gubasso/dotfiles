function __python_project_setup --description 'If cwd is a python project, run mise activation and venv activation as applicable'
    __is_python_project; or return 0

    __maybe_mise_activate; or return
    __poetry_activate; or return

    # If no virtual environment is active after Poetry attempt, create/activate .venv
    if not set -q VIRTUAL_ENV
        __venv_activate; or return
    end

    return 0
end
