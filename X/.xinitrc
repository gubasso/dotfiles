#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then


    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#############
# gubasso's #
#############

[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile
[ -f ~/.profile ] && source ~/.profile

# ssh-agent start with X, integration with keepassxc
# eval $(ssh-agent)

# Setup br abnt2 keyboard layout with dead keys and accents
# Switch caps lock and Esc
# setxkbmap -model abnt2 -layout br -option "caps:swapescape"

# hide mouse when typing
xbanish &

# Run KDE Plasma
export DESKTOP_SESSION=plasma
exec startplasma-x11
