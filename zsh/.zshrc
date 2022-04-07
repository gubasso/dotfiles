#
# ~/.zshrc
#

source ~/.shell_alias
source ~/.shell_env_vars

# gitignore generator [^1]
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}

# asdf
. /opt/asdf-vm/asdf.sh

#######
# Fzf #
#######
# References:
# [^fzf1]: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# sources
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

#########################
# End: Needs to be at the end
#########################

eval "$(starship init zsh)"

# References
# [1]: [gitignore.io: command line](https://docs.gitignore.io/install/command-line)
