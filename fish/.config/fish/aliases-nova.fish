function pup --description 'Update system, dev tools and firmware'
  arch-update
  rustup update
  cargo install-update -a
  pipx upgrade-all
  fwupdmgr refresh --force
  sudo fwupdmgr update
end
