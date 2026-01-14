function __mise_activate --description 'Activate mise for fish shell'
    __require mise; or return

    mise activate fish | source
    set -l ps $pipestatus

    if test $ps[1] -ne 0
        __log_err "mise activate fish failed. Exit status:" $ps[1]
        return 1
    end
    if test $ps[2] -ne 0
        __log_err "Failed to source mise activation output. Exit status:" $ps[2]
        return 1
    end

    __log_info "Activated mise environment."
    return 0
end
