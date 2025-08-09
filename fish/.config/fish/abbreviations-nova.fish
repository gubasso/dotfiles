abbr -a clip  "wl-copy"

abbr -a pin   "paru -Syu --needed"
abbr -a psr   "paru -Ss"
abbr -a psi   "paru -Qs"
abbr -a prm   "paru -Rs"

function up
  paru -Syu $argv
  notify-send "up" "System updated"
end

