function __poetry_activate --description 'If cwd is a Poetry project, activate its venv in fish; otherwise do nothing'
    __is_poetry_project
    set -l poetry_detect_status $status

    switch $poetry_detect_status
        case 0
            __require poetry; or return

            # Capture stdout only; stderr goes to temp file for error reporting
            set -l stderr_file (mktemp)
            set -l snippet (poetry env activate 2>$stderr_file | string collect)
            set -l ps $pipestatus
            set -l cmd_status $ps[1]

            if test $cmd_status -ne 0
                # Check for recoverable "missing activator" error
                set -l stderr_content (cat $stderr_file 2>/dev/null)
                if string match -q '*activator*' -- "$stderr_content"
                    __log_info "Detected missing Fish activator; attempting recovery..."
                    rm -f $stderr_file

                    # Remove all environments and reinstall
                    if not poetry env remove --all 2>/dev/null
                        __log_err "poetry env remove --all failed"
                        return 1
                    end

                    if not poetry install 2>/dev/null
                        __log_err "poetry install failed during recovery"
                        return 1
                    end

                    __log_info "Recovery complete; retrying activation..."

                    # Retry activation (single attempt)
                    set stderr_file (mktemp)
                    set snippet (poetry env activate 2>$stderr_file | string collect)
                    set ps $pipestatus
                    set cmd_status $ps[1]

                    if test $cmd_status -ne 0
                        __log_err "poetry env activate still failed after recovery (exit $cmd_status)."
                        if test -s $stderr_file
                            while read -l line
                                if test -n "$line"
                                    __log_err "  $line"
                                end
                            end < $stderr_file
                        end
                        rm -f $stderr_file
                        return 1
                    end
                    rm -f $stderr_file
                    # Fall through to eval the snippet
                else
                    # Non-recoverable error
                    __log_err "poetry env activate failed (exit $cmd_status)."
                    if test -s $stderr_file
                        __log_err "stderr output:"
                        while read -l line
                            if test -n "$line"
                                __log_err "  $line"
                            end
                        end < $stderr_file
                    end
                    __log_err "Common causes:"
                    __log_err "  - virtualenv not created (run: poetry install)"
                    __log_err "  - Fish activator missing (run: poetry env remove --all && poetry install)"
                    rm -f $stderr_file
                    return 1
                end
            else
                rm -f $stderr_file
            end

            if test -z "$snippet"
                __log_err "poetry env activate produced no output."
                return 1
            end

            # Safe to eval now - command succeeded
            eval "$snippet"
            set -l eval_status $status
            if test $eval_status -ne 0
                __log_err "Fish failed to evaluate Poetry activation snippet (exit $eval_status)."
                __log_err "Snippet was:"
                for line in (string split \n -- "$snippet")
                    if test -n "$line"
                        __log_err "  $line"
                    end
                end
                return 1
            end

            if not set -q VIRTUAL_ENV
                __log_err "Poetry environment does not appear active (VIRTUAL_ENV is not set)."
                return 1
            end

            __log_info "Activated Poetry virtualenv:" $VIRTUAL_ENV
            return 0

        case 1
            __log_info "Not a Poetry project; skipping poetry activation."
            return 0

        case '*'
            # Error already logged by __is_poetry_project
            return 1
    end
end
