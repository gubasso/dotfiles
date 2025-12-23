function __poetry_activate --description 'If cwd is a Poetry project, activate its venv in fish; otherwise do nothing'
    __is_poetry_project
    set -l poetry_detect_status $status

    switch $poetry_detect_status
        case 0
            __require poetry; or return

            set -l poetry_cmd (poetry env activate 2>&1 | string collect)
            set -l poetry_status $status

            if test $poetry_status -ne 0
                __err_exit "poetry env activate failed:" $poetry_cmd
                return 1
            end
            if test -z "$poetry_cmd"
                __err_exit "poetry env activate produced no output."
                return 1
            end

            eval "$poetry_cmd"
            if test $status -ne 0
                __err_exit "eval (poetry env activate) failed."
                return 1
            end

            if not set -q VIRTUAL_ENV
                __err_exit "Poetry environment does not appear active (VIRTUAL_ENV is not set)."
                return 1
            end

            __info "Activated Poetry virtualenv:" $VIRTUAL_ENV
            return 0

        case 1
            __info "Not a Poetry project; skipping poetry activation."
            return 0

        case '*'
            # Error already logged by __is_poetry_project
            return 1
    end
end
