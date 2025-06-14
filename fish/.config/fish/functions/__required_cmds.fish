function __required_cmds
  set -l missing
  for cmd in $argv
    if not type -q $cmd
      set missing $missing $cmd
    end
  end

  if test (count $missing) -gt 0
    echo ""
    echo "\033[1;31mError:\033[0m Missing dependencies: $(string join ', ' $missing)"
    echo "Please install: $missing"
    # return 1  # uncomment if you want to stop loading the rest of config.fish
    echo ""
  end
end
