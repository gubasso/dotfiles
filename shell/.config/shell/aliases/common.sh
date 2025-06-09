###########
# Aliases #
###########
# References:
# [^al1]: https://www.homeonrails.com/2016/05/truecolor-in-gnome-terminal-tmux-and-neovim/
# [^al2]: My notes, Dotfiles
# [^al3]: [Clear a terminal screen for real: KDE](https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real)
# [^al4]: `cat file | xclip -selection clipboard` [How can I copy the output of a command directly into my clipboard?](https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#5130969)

alias n="nvim"
alias sn="sudoedit"
alias md="mkdir -p"
alias '..'="cd .."
alias 'cd..'="cd .."
alias htop='btm'
alias rms="shred -n10 -uz"
# https://github.com/andreafrancia/trash-cli
alias rm='echo "This is not the command you are looking for."; false'
alias rmt='trash-put'
# alias ls='eza'
# alias ll='eza -la'
alias ls='ls --color=auto'
alias ll='ls -la'
alias tree='eza --tree --all --git-ignore --ignore-glob ".git"'
alias cat='bat'
alias rg='rg --hidden --smart-case'
alias cl='clear'
alias clrm='clear && echo -en "\e[3J"' #[^al3]
alias ss='sudo systemctl'
alias sudo="sudo "
alias rs='rsync -vurzP'

# wezvim: cd into $1, tell WezTerm about it, then open nvim
wezvim() {
  local open_nvim=false
  local dir

  if [[ $1 == -e || $1 == --edit ]]; then
    open_nvim=true
    shift
  fi

  if [[ -z $1 ]]; then
    echo "Usage: wezvim [-e|--edit] <directory>" >&2
    return 1
  fi
  dir=$1

  if [[ ! -d $dir ]]; then
    echo "⛔ Directory not found: $dir" >&2
    return 1
  fi

  cd -- "$dir" || return

  if $open_nvim; then
    # notify WezTerm of the new cwd (so e.g. cmd-click in the title bar works)
    if command -v wezterm &>/dev/null; then
      wezterm set-working-directory "$PWD"
    else
      # fallback to raw OSC-7 if wezterm CLI isn't available
      printf '\033]7;file://%s%s\033\\' "$(hostname)" "$PWD"
    fi
    nvim
  fi
}

alias docs='wezvim -e "$HOME"/DocsNNotes'
alias todo='wezvim -e "$HOME"/Todo'
alias notes='wezvim -e "$HOME"/Notes'
alias dot='wezvim "$HOME"/.dotfiles'

function now() {
  date "+%Y-%m-%d %H:%M:%S" | tr -d '\n' | tee >(clip)
}
function slug() {
  slugify --separator _ "${@}" | tr -d '\n' | tee >(clip)
}

# docker ----------------------------------------------------------------------
alias d='docker'
alias dc='docker compose'

# git -------------------------------------------------------------------------
alias ga='git add -A'
alias gac='git add -A && git commit'
alias gacm='git add -A && git commit -m'
function gacmp() { gacm "${@}" && git push ;}
alias gauthor='printf "$(git config --local user.name) <$(git config --local user.email)>"'
alias gp='git push'
alias gpu='git push --set-upstream origin'
alias gpl='git pull'
alias gplu='git pull --set-upstream origin'
alias gup='git add -A && git commit -m "up" && git push'
alias gs='git switch'
## git branch
alias gb='git --no-pager branch'
alias gbd='git branch -d'
alias gbn='git switch -c'
function gbnu() {
  if [ -z "$1" ]; then
    echo "Usage: gnbu <new-branch-name>"
    return 1
  fi
  new_branch_name="$1"
  git switch -c "$new_branch_name"
  git pull --set-upstream origin "$new_branch_name"  || return 1
  git push --set-upstream origin "$new_branch_name"
}

# pre-commit + git
alias pre='git add -A && pre-commit run'

# gitignore generator
function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}

# dev
alias poetry_activate='eval "$(poetry env activate)"'
