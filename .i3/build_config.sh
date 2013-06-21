#!/bin/bash
folder="$HOME/.i3"

wallpaper="/home/teto/Images/route66.png"


#generate screens variables
source "$folder/xrandr.sh" 

res="$(i3_build_outputs_config)"
echo "$res" > "$folder/config.monitors"

command="$(xrandr_build_command)"

eval "$command"

echo "bindsym \$mod+Shift+m exec $command;" >> "$folder/config.monitors"

echo "set \$wallpaper $wallpaper" > "$folder/config"

#list=$( find . -regex './config\..*' -print)
#for config_part in $list; do

list="$folder/config.header $folder/config.monitors $folder/config.mediakeys $folder/config.main"
cat $list > "$folder/config"

#cat "$folder/config.monitors" "$folder/config.main" > "$folder/config"
