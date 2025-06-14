__required_cmds git

function gacmp
  if test (count $argv) -eq 0
    echo "Usage: gacmp <commit message>"
    return 1
  end

  set msg (string join " " $argv)

  git add -A
  and git commit -m "$msg"
  and git push
end
