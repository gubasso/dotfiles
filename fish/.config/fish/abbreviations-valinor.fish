abbr -a clip 'wl-copy'
abbr -a sp   'paru -Ss'
abbr -a spi  'paru -Q | rg'

function up
  paru -Syu $argv
  notify-send "up" "System updated"
end

