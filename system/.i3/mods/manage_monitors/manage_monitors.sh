#!/bin/bash
NOTIFY="notify-send"

source xrandr.sh

# list of monitors
monitors="$(xrandr_list_connected_monitors)"


# @param 
function choose_monitor()
{


local dmenu_input=""

for monitor in $monitors; do
	dmenu_input="$dmenu_input\n$monitor"

done

echo -e "$dmenu_input" | dmenu -p "Choose a monitor:"
}


chosen_output=$(choose_monitor)


function choose_action() 
{


# could add "clone" ?
echo -e "Disable\nTop\nLeft\nRight\nBottom" | dmenu -p "Choose an action:"

}

action=$(choose_action)

if $action == "Disable"; then


fi


# else we need to find the other monitor to place relatively to 
# for now we compare


case $action in 

	"Disable")
		cmd="xrandr --output $chosen_output --off "
		;;
	"Top")	cmd="xrandr --above"
	"Left")  --left-of
	"Right") --right-of
	"Bottom") --below

	default)
		$NOTIFY "invalid action"
		;;
esac
