#!/bin/sh

#############
# gubasso's #
#############

[ -f ~/.xprofile ] && source ~/.xprofile
[ -f ~/.profile ] && source ~/.profile

# ssh-agent start with X, integration with keepassxc
# eval $(ssh-agent)

# Setup br abnt2 keyboard layout with dead keys and accents
# Switch caps lock and Esc
setxkbmap -model abnt2 -layout br -option "caps:swapescape"

# hide mouse when typing
xbanish &

# Run KDE Plasma
export DESKTOP_SESSION=plasma
exec startplasma-x11
