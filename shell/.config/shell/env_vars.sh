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


# d`zinit pack for ls_colors` at .zshrc can substitute this
# https://github.com/zdharma-continuum/zinit-packages/tree/main/ls_colors
# generate with `dircolors` command
# https://unix.stackexchange.com/questions/545413/setting-ls-colors-has-no-effect
# LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';
# export LS_COLORS
# export GTK_THEME=Adwaita:dark
# export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
# export QT_STYLE_OVERRIDE=Adwaita-Dark

export DOTFILESDIR="${HOME}/.dotfiles"
export VISUAL=nvim
export EDITOR=nvim
export TERMINAL=wezterm

export R_PROFILE_USER="$XDG_CONFIG_HOME/R"
export R_HOME_USER="$HOME/.R"

export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"

export CLOUD_DIR="$HOME/Nextcloud"

SOLANA_PATH="$XDG_DATA_HOME/solana/install/active_release/"

export PATH="$PATH:$GOBIN:$SOLANA_PATH"
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"

# . "$HOME/.cargo/env"
