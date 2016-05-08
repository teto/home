#!/bin/bash

# TODO replace with compton
#xcompmgr&

# launch mpd in user mode
mpd &

# need to launch daemon before i3, cos of scratchpads
#urxvtd -q -o -f&

# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "$HOME/.zshenv"

# alsamixer in systray
# regenerate i3 config
"$XDG_CONFIG_HOME/i3/build_config.sh"

xrdb -I"$HOME" "$HOME/.Xresources"

# Set background color
xsetroot -solid "#333333"

# Enable core dumps in case something goes wrong
ulimit -c unlimited

# Start i3 and log to ~/.i3/logfile
# echo "Starting at $(date)" >> ~/.i3/logfile
# exec /usr/bin/i3 -V -d all >> ~/.i3/logfile

# clipboard manager
parcellite&
# network manager systray icon
#nm-applet&
xmodmap ~/.Xmodmap

# should be loaded automatically
# Please see http://i3wm.org/docs/userguide.html for a complete reference! 
