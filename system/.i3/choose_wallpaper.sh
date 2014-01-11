#!/bin/bash
imgPath="$HOME/Images"

list=$(find "$imgPath" -maxdepth 2 -type f -printf "%f\n")
choice=$(echo -e "$list" | dmenu)

img="$imgPath/$choice"
notify-send "Setting new wallpaper $img"
feh --bg-scale "$img"
