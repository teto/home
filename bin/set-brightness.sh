


getBrightness() {
  brightnessctl -m info | cut -f4 -d, 
}

action="$1"
delta="${2:-10}"

# write it in lisp ?
if [ "$action" = "up" ]; then

  if ! brightnessctl set +10%; then
    notify-send --icon=brightness -u low -t 1000 -h string:synchronous:brightness-level 'Brightness' 'Failed to raise brightness'
  else
     notify-send --icon=brightness -u low -t 1000 -h int:value:$(getBrightness) -e -h string:synchronous:brightness-level 'Brightness' 'Raised brightness'
  fi
else 
  # todo 
  echo "decrease brightness"
fi
  
