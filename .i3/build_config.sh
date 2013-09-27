#!/bin/bash
folder="$HOME/.i3"

#wallpaper="/home/teto/Images/route66.png"


#generate screens variables
python "$folder/generate_monitors_config.py" > "$folder/config.monitors"

#echo "set \$wallpaper $wallpaper" > "$folder/config"

#list=$( find . -regex './config\..*' -print)
#for config_part in $list; do

list="$folder/config.header $folder/config.monitors $folder/config.mediakeys $folder/config.main"
cat $list > "$folder/config"

#cat "$folder/config.monitors" "$folder/config.main" > "$folder/config"
