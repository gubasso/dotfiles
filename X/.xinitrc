#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#############
# gubasso's #
#############

[ -f ~/.xprofile ] && source ~/.xprofile
[ -f ~/.profile ] && source ~/.profile

# ssh-agent start with X, integration with keepassxc
# eval $(ssh-agent)

# Setup br abnt2 keyboard layout with dead keys and accents
# Switch caps lock and Esc
# setxkbmap -model abnt2 -layout br -option "caps:swapescape"

# hide mouse when typing
xbanish &

pcmanfm -d &

dunst &

sxhkd &

dwmblocks &

dropbox &

thunar --daemon &

xset r rate 300 50
# exec startdwm
exec dwm
