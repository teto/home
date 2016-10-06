#!/bin/bash
# ================================================================================== #
# Focus the next window on the current workspace in i3, e.g. for binding to Alt+Tab  #
# Depends: jq, awk, i3wm (obviously)                                                 #
# Author: Nervengift <dev@nerven.gift>                                               #
# License: Don't think this deserves a license, Public Domain                        #
# Known bugs: doesn't work with non-window container focused                         #
# ================================================================================== #

ws=$(i3-msg -t get_workspaces|jq "map(select(.focused))[]|.name")
windows=$(i3-msg -t get_tree|jq ".nodes|map(.nodes[])|map(.nodes[])|map(select(.type==\"workspace\" and .name==$ws))[0].nodes|map(recurse(.nodes[]))|map(.window)|.[]|values")
current=$(i3-msg -t get_tree|jq "recurse(.nodes[])|select(.focused)|.window")
if [ "x$current" != "xnull" ]; then
	next=$(echo $windows | awk "BEGIN {RS=\" \";FS=\"   \"};NR == 1 {w=\$1};{if (f == 1){w=\$1;f=0}else if (\$1 == \"$current\") f=1};END {print w}")
	i3-msg [id=$next] focus > /dev/null
fi
