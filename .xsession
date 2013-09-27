#!/bin/bash

xcompmgr&

urxvtd -q -o -f&

feh --bg-scale Images/abstrait2.jpg&

# alsamixer in systray
volumeicon& 
"$HOME/.i3/build_config.sh"


# Please see http://i3wm.org/docs/userguide.html for a complete reference! 
