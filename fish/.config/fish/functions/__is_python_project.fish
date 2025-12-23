function __is_python_project --description 'Return 0 if cwd looks like a Python project'
    test -f pyproject.toml -o -f setup.py -o -f requirements.txt -o -f Pipfile
end
