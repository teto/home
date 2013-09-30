#!/bin/bash
folder="$HOME/.i3"

#wallpaper="/home/teto/Images/route66.png"


#generate screens variables
python "$folder/generate_monitors_config.py" > "$folder/config.monitors"

# if generation failed
if [ $? -ne 0 ]; then
	i3-nagbar -m "Could not configure monitors properly. Falling back"&
	echo -e "set \$output1 LVDS\nset \$output2 LVDS" > "$folder/config.monitors"
fi
#echo "set \$wallpaper $wallpaper" > "$folder/config"

#list=$( find . -regex './config\..*' -print)
#for config_part in $list; do

list="$folder/config.header $folder/config.monitors $folder/config.mediakeys $folder/config.main"
cat $list > "$folder/config"

#cat "$folder/config.monitors" "$folder/config.main" > "$folder/config"
