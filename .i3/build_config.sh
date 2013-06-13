#!/bin/bash
folder="$HOME/.i3"

#generate screens variables
"$folder/xrandr.sh" > "$folder/config.monitors"


#list=$( find . -regex './config\..*' -print)
#for config_part in $list; do

list="config.monitors config.mediakeys config.main"
cat $list > "$folder/config"

#cat "$folder/config.monitors" "$folder/config.main" > "$folder/config"
