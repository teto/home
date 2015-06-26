#!/bin/bash

# TODO replace with compton
#xcompmgr&
xrdb -override $HOME/.Xresources

. "$HOME/.zshenv"
# echo $PYTHONPATH
mpd&

# need to launch daemon before i3, cos of scratchpads
urxvtd -q -o -f&

# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp


feh --bg-scale Images/abstrait2.jpg&

# alsamixer in systray
"$HOME/.i3/build_config"

# Set background color
xsetroot -solid "#333333"

# Enable core dumps in case something goes wrong
ulimit -c unlimited

# Start i3 and log to ~/.i3/logfile
# echo "Starting at $(date)" >> ~/.i3/logfile
# exec /usr/bin/i3 -V -d all >> ~/.i3/logfile


parcellite&

# Please see http://i3wm.org/docs/userguide.html for a complete reference! 
