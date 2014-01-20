#!/bin/bash

# TODO replace with compton
#xcompmgr&

# need to launch daemon before i3, cos of scratchpads
urxvtd -q -o -f&


feh --bg-scale Images/abstrait2.jpg&

# alsamixer in systray
"$HOME/.i3/build_config.sh"




# Please see http://i3wm.org/docs/userguide.html for a complete reference! 
