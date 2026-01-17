abbr -a zref 'sudo zypper refresh'
abbr -a zin 'sudo zypper in'
abbr -a zrin 'sudo zypper refresh; and sudo zypper in'
abbr -a zrm 'sudo zypper rm'
abbr -a zsr 'zypper search'

function zup
  # Tumbleweed snapshot update (recommended way for TW)
  sudo zypper ref
  sudo zypper dup

  # Flatpaks (Discover apps/runtimes)
  flatpak update

  # Homebrew
  brew update
  brew upgrade
  brew cleanup

  # Toolchains / language-level package managers
  rustup update
  cargo install-update -a
  pipx upgrade-all
  npm update -g

  # Firmware (Discover firmware / “hardware updates”)
  sudo fwupdmgr refresh
  sudo fwupdmgr update
end

