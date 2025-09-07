function sudo
  command sudo -v
  command sudo $argv
end

alias tree='eza --tree --all --git-ignore --ignore-glob ".git" --color=always'
