#!/bin/bash
folder="$HOME/.i3"

#wallpaper="/home/teto/Images/route66.png"


#generate screens variables with filename in parameter
python3 "$folder/generate_monitors_config.py"  "$folder/config.monitors"



# if generation failed
if [ $? -ne 0 ]; then
	i3-nagbar -m "Could not configure monitors properly. Falling back"&
    output=$(xrandr -q| grep " connected"| cut -d' ' -f1)
	echo -e "set \$output1 $output\nset \$output2 $output" > "$folder/config.monitors"
fi
#echo "set \$wallpaper $wallpaper" > "$folder/config"

#list=$( find . -regex './config\..*' -print)
#for config_part in $list; do

list="$folder/config.header  $folder/config.xp $folder/config.monitors $folder/config.colors $folder/config.mediakeys $folder/filters.config $folder/config.main "
cat $list > "$folder/config"

#cat "$folder/config.monitors" "$folder/config.main" > "$folder/config"
