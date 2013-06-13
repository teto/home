#!/bin/bash

command="xrandr "
previous_monitor=""

# @param name of the variable to save into
function x11_list_monitors()
{
	local monitors=$(xrandr | grep ' connected' | cut -d' ' -f1)
	read $1 < "$monitors"
}


function is_a_number()
{
	echo "TODO"
}


# without blank , greps also 'disconnected' monitors
i=1
monitors=$(xrandr | grep ' connected' | cut -d' ' -f1)

for monitor in $monitors; do

	echo "set \$output${i} $monitor"
	
	command="$command --output $monitor --auto "
	if [ ! -z $previous_monitor ]; then
		command="$command --right-of $previous_monitor"
	fi
	previous_monitor=$monitor

	# care: blanks needed
	i=$(expr $i + 1)
done

#echo $command

eval "$command"



if [ $? != "0" ]; then
	notify-send "Xrandr error"
fi

exit

done 
    if [$? -eq 0]; then
        # External monitor is connected
        xrandr --output VGA --mode 1280x1024 --pos 0x0 --output LVDS --mode 1400x1050 --pos 0x998
        if [$? -ne 0]; then
            # Something went wrong. Autoconfigure the internal monitor and disable the external one
            xrandr --output LVDS --mode auto --output VGA --off
        fi
    else
        # External monitor is not connected
        xrandr --output LVDS --mode 1400x1050 --output VGA --off
    fi

