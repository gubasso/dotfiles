# fzf
set -l tree_cmd 'eza --tree --all --git-ignore --ignore-glob ".git" --color=always'

set -x FZF_DEFAULT_COMMAND "fd --hidden --follow --color=always"
set -x FZF_DEFAULT_OPTS "
  --select-1 --exit-0
  --walker-skip ".git,node_modules,target"
  --no-height
  --layout=reverse
  --ansi
  --inline-info"

## CTRL_T
set -l bat_cmd "bat -n --color=always"
set -l preview "begin; $bat_cmd {} 2>/dev/null; or $tree_cmd {} 2>/dev/null; end | head -200"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_CTRL_T_OPTS "--preview \"$preview\""

## ALT_C
set -x FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND --type d"
set -x FZF_ALT_C_OPTS "--preview \"$tree_cmd {} | head -200\""

## CTRL_R
# bat_shell="bat --language sh --plain --color=always"
set -x FZF_CTRL_R_OPTS "
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {} | xclip -selection clipboard)+abort'
  --color header:italic
  --header 'Press ^y to copy command into clipboard'"

fzf --fish | source
