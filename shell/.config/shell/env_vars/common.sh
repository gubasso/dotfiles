#########################
# Environment Variables #
#########################

# fzf
## vars
skip=".git,node_modules,target"
bat_cmd="bat -n --color=always"
tree_cmd='eza --tree --all --git-ignore --ignore-glob ".git" --color=always'
preview="($bat_cmd {} 2> /dev/null || $tree_cmd {} 2> /dev/null) | head -200"


## Defaults
export FZF_DEFAULT_COMMAND="fd --hidden --follow --color=always"
export FZF_DEFAULT_OPTS="
  --select-1 --exit-0
  --walker-skip $skip
  --no-height
  --layout=reverse
  --ansi
  --inline-info"
export FZF_TMUX=1
## CTRL_T
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview '$preview'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
## ALT_C
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_ALT_C_OPTS="
  --preview '$tree_cmd {} | head -200'"
## CTRL_R
# bat_shell="bat --language sh --plain --color=always"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {} | xclip -selection clipboard)+abort'
  --color header:italic
  --header 'Press ^y to copy command into clipboard'"
## COMPLETIONS **
export FZF_COMPLETION_OPTS="
  --preview '$preview'
  --info=inline"
_fzf_compgen_path() {
  fd --hidden --follow --color=always . "$1"
}

_fzf_compgen_dir() {
  fd --hidden --follow --color=always --type d . "$1"
}

export DOTFILESDIR="${HOME}/.dotfiles"
export VISUAL=nvim
export EDITOR=nvim
export SUDO_EDITOR="$EDITOR"
export TERMINAL=wezterm

export R_PROFILE_USER="$XDG_CONFIG_HOME/R"
export R_HOME_USER="$HOME/.R"

# PATH / BIN -----------------------------------------------------------------
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"

PATH="$GOBIN:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.npm-global/bin:$PATH"
export PATH

