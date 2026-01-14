function __mise_python_setup --description 'Auto-detect Python version from pyproject.toml and set up mise'
    # Skip if mise.toml already exists
    if test -f mise.toml
        return 0
    end

    # Skip if no pyproject.toml
    if not test -f pyproject.toml
        __log_info "No pyproject.toml found; skipping mise Python setup."
        return 0
    end

    __require mise tomlq; or return

    # Extract Python version using tomlq
    # Try PEP 621 standard first: [project] requires-python
    set -l python_version (tomlq -r '.project."requires-python" // empty' pyproject.toml 2>/dev/null)

    # Fallback: Poetry style [tool.poetry.dependencies] python
    if test -z "$python_version"
        set python_version (tomlq -r '.tool.poetry.dependencies.python // empty' pyproject.toml 2>/dev/null)
    end

    if test -z "$python_version"
        __log_info "Could not detect Python version from pyproject.toml; skipping mise setup."
        return 0
    end

    # Store raw spec for logging, then parse to target version
    set -l version_spec $python_version
    set python_version (__parse_version_spec "$version_spec")

    if test -z "$python_version"
        __log_info "Could not parse Python version from '$version_spec'; skipping mise setup."
        return 0
    end

    __log_info "Detected Python version spec '$version_spec' → targeting $python_version"

    # Install and configure mise with detected Python version
    mise use "python@$python_version"
    if test $status -ne 0
        __log_err "mise use python@$python_version failed."
        return 1
    end

    __log_info "Created mise.toml with Python $python_version"

    # Activate mise using the dedicated function
    __mise_activate; or return

    __log_info "Mise Python setup complete with Python $python_version"
    return 0
end
