# ~/.bash_profile
[ -f ~/.xprofile ] && source ~/.xprofile
[ -f ~/.profile ] && source ~/.profile
. "$HOME/.cargo/env"

export PATH="/home/gubasso/.local/share/solana/install/active_release/bin:$PATH"
. "$XDG_DATA_HOME/dfx/env"
