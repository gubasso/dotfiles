# Keep fish PATH consistent across host and containers.
# fish_add_path ignores missing dirs and avoids duplicates.
# "duplicates/mirror" ~/.profile

fish_add_path -m ~/.local/bin
fish_add_path -m ~/.local/npm/bin
fish_add_path -m ~/.cargo/bin
