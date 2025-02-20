alias clip='xclip -selection clipboard'

function up() {
  install_aws_cli_v2
  flatpak update
  rustup update
  cargo install-update -a
  pipx upgrade-all
  sudo zypper refresh
  sudo zypper up -y
  sudo zypper dup
  # sudo fwupdmgr refresh
  # sudo fwupdmgr update --assume-yes
}

alias zref="sudo zypper refresh"
alias zin="sudo zypper refresh && sudo zypper in"
alias zsr="zypper search"
