source "$UTILS_DIR/helpers.sh"

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
alias clrm='clear && echo -en "\e[3J"' #[^1]
alias ss='sudo systemctl'
alias sudo="sudo "
alias rs='rsync -vurzP'

alias docs='wezvim -e "$HOME"/DocsNNotes'
alias todo='wezvim -e "$HOME"/Todo'
alias notes='wezvim -e "$HOME"/Notes'
alias dot='wezvim "$HOME"/.dotfiles'

# docker ---------------------------------------------------------------
alias d='docker'
alias dc='docker compose'

# git ------------------------------------------------------------------
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
## gitignore generator
gi() {
  if [[ -z $1 ]]; then
    echo "Usage: gi <language>" >&2
    return 1
  fi
  curl -sL "https://www.toptal.com/developers/gitignore/api/${1}"
}
## pre-commit + git
alias pre='git add -A && pre-commit run'

# dev ---------------------------------------------------------
alias poetry_activate='eval "$(poetry env activate)"'

# tools ---------------------------------------------------------
function now() {
  date "+%Y-%m-%d %H:%M:%S" | tr -d '\n' | tee >(clip)
}

function slug() {
  slugify --separator _ "${@}" | tr -d '\n' | tee >(clip)
}

# References --------------------------------------------
# [^1]: [Clear a terminal screen for real: KDE](https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real)
