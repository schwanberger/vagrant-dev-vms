#!/bin/sh

# Lightweight X-session for VM's
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

/usr/bin/VBoxClient-all
setxkbmap dk
#exec xterm
#exec emacs
exec i3
