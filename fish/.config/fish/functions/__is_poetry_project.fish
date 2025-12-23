function __is_poetry_project --description 'Return 0 if cwd looks like a Poetry project; 1 if not; 2 on error'
    if test -f poetry.lock
        return 0
    end

    if test -f pyproject.toml
        __require rg; or return 2

        rg -q '^\[tool\.poetry\]' pyproject.toml
        switch $status
            case 0
                return 0
            case 1
                return 1
            case '*'
                __err_exit "rg failed while checking pyproject.toml for [tool.poetry]. Exit status:" $status
                return 2
        end
    end

    return 1
end
