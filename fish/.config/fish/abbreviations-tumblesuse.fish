abbr -a clip 'xclip -selection clipboard'
abbr -a zref 'sudo zypper refresh'
abbr -a zin 'sudo zypper in'
abbr -a zrin 'sudo zypper refresh; and sudo zypper in'
abbr -a zrm 'sudo zypper rm'
abbr -a zsr 'zypper search'

# --- functions -----------------------------------------
function up
  sudo zypper refresh
  sudo zypper dup
  install_aws_cli_v2
  flatpak update
  rustup update
  cargo install-update -a
  pipx upgrade-all
  npm update -g
  # sudo fwupdmgr refresh
  # sudo fwupdmgr update --assume-yes
end

