###########
# Aliases #
###########
# References:
# [^al1]: https://www.homeonrails.com/2016/05/truecolor-in-gnome-terminal-tmux-and-neovim/
# [^al2]: My notes, Dotfiles
# [^al3]: [Clear a terminal screen for real: KDE](https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real)
# [^al4]: `cat file | xclip -selection clipboard` [How can I copy the output of a command directly into my clipboard?](https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#5130969)

alias n="nvim"
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
alias dot='cd "$HOME"/.dotfiles'
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
## git new branch
alias gnb='git switch -c'
function gnbu() {
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

#gopass
alias gop='gopass'
alias gops='gopass show'
alias gopy='gopass sync'
alias gope='gopass edit'

# gitignore generator
function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}

# dev
alias poetry_activate='eval "$(poetry env activate)"'
