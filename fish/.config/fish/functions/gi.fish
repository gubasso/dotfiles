__required_cmds curl

function gi
  if test (count $argv) -ne 1
    echo "Usage: gi <language>"
    return 1
  end
  curl -sL "https://www.toptal.com/developers/gitignore/api/$argv"
end
