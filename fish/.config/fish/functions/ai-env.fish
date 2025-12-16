function ai-env --description "Load API keys from .env.ai in the current directory and run a command"
    if test -f .env.ai
        for line in (string split "\n" (cat .env.ai))
            set line (string trim $line)
            if test -z "$line"
                continue
            end
            if string match -q '#*' -- $line
                continue
            end
            set kv (string split -m 1 '=' $line)
            if test (count $kv) -eq 2
                set -gx $kv[1] $kv[2]
            end
        end
    end

    if test (count $argv) -eq 0
        echo "ai-env: missing command"
        echo "Usage: ai-env <command> [arguments...]"
        return 1
    end

    $argv
end
