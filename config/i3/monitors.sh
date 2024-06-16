#!/bin/sh
# TODO: in case you got several screen should run on focused screen
# and propose left/right
xrandr --output VGA-0 --off --output DVI-0 --off --output LVDS --auto

i3-nagbar -m "EBRND'S SUPER-COOL I3WM SCREEN CONFIG UTILITY" -t warning \
  -b "LVDS + DVI" "xrandr --output VGA-0 --off --output LVDS --auto --output DVI-0 --auto --right-of LVDS" \
  -b "LVDS + VGA" "xrandr --output DVI-0 --off --output LVDS --auto --output VGA-0 --auto --right-of LVDS" \
  -b "VGA ONLY" "xrandr --output LVDS --off --output DVI-0 --off --output VGA-0 --auto"

sh ~/.fehbg
