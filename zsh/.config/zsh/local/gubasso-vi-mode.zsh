## vi mode: substituted by zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
### Change cursor shape for different vi modes.
#### https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
### function zle-keymap-select {
###   if [[ ${KEYMAP} == vicmd ]] ||
###      [[ $1 = 'block' ]]; then
###     echo -ne '\e[2 q'
###   elif [[ ${KEYMAP} == main ]] ||
###        [[ ${KEYMAP} == viins ]] ||
###        [[ ${KEYMAP} = '' ]] ||
###        [[ $1 = 'beam' ]]; then
###     echo -ne '\e[6 q'
###   fi
### }
### zle -N zle-keymap-select
### zle-line-init() {
###     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
###     echo -ne "\e[6 q"
### }
### zle -N zle-line-init
### echo -ne '\e[6 q' # Use beam shape cursor on startup.
### preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
### Keybindings
#### vi mode
### bindkey -v
### bindkey -v '^?' backward-delete-char
### export KEYTIMEOUT=1
#### Edit line in vim with ctrl-e:
###autoload edit-command-line; zle -N edit-command-line
###bindkey '^e' edit-command-line
