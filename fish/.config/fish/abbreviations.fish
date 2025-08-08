abbr -a !!       --position anywhere --function last_history_item
abbr -a cd       z
abbr -a docs     "z $HOME/DocsNNotes; nvim"
abbr -a todo     "z $HOME/Todo; nvim"
abbr -a notes    "z $HOME/Notes; nvim"
abbr -a dot      "z $HOME/.dotfiles"
abbr -a n        nvim
abbr -a sn       sudoedit
abbr -a md       "mkdir -p"
abbr -a htop     btm
abbr -a rms      "shred -n10 -uz"
abbr -a rm       trash-put
abbr -a ls       eza
abbr -a ll       "eza -la"
abbr -a tree     "eza --tree --all --git-ignore --ignore-glob '.git'"
abbr -a cat      bat
abbr -a rg       "rg --hidden --smart-case"
abbr -a cl       clear
abbr -a clrm     'clear && echo -en "\e[3J"'
abbr -a ss       "sudo systemctl"
abbr -a rs       "rsync -vurzP"
abbr -a pre      "pre-commit run"
abbr -a ma       "mise activate fish | source"
abbr -a pa       "eval (poetry env activate)"
abbr -a py_dev   "mise activate fish | source; and eval (poetry env activate)"
# docker
abbr -a d        docker
abbr -a dc       'docker compose'
# git
abbr -a ga       'git add -A'
abbr -a gac      'git add -A; and git commit'
abbr -a gacm     'git add -A; and git commit -m'
abbr -a gp       'git push'
abbr -a gpu      'git push --set-upstream origin'
abbr -a gpl      'git pull'
abbr -a gplu     'git pull --set-upstream origin'
abbr -a gup      'git add -A; and git commit -m "up"; and git push'
abbr -a gs       'git switch'
# git branch
abbr -a gb       'git --no-pager branch'
abbr -a gbd      'git branch -d'
abbr -a gbn      'git switch -c'
