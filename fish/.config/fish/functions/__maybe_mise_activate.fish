function __maybe_mise_activate --description 'If mise.toml exists in cwd, activate mise for fish; otherwise log and do nothing'
    if not test -f mise.toml
        __info "No mise.toml found; skipping mise activation."
        return 0
    end

    __require mise; or return

    mise activate fish | source
    set -l ps $pipestatus

    if test $ps[1] -ne 0
        __err_exit "mise activate fish failed. Exit status:" $ps[1]
        return 1
    end
    if test $ps[2] -ne 0
        __err_exit "Failed to source mise activation output. Exit status:" $ps[2]
        return 1
    end

    __info "Activated mise environment."
    return 0
end
