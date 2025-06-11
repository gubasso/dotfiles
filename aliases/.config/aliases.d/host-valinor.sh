alias clip='wl-copy'
alias sp="paru -Ss"
alias spi="paru -Q | rg"

function up() {
  paru -Syu "${@}"
  notify-send "up" "System updated"
}

