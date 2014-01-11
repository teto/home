#!/bin/bash

command="xrandr "
previous_monitor=""

# @param name of the variable to save into
function xrandr_list_connected_monitors()
{
	local _monitors_list=$(xrandr | grep ' connected' | cut -d' ' -f1)
	# read $1 <<< "$monitors_list"
	echo $_monitors_list
}


function xrandr_number_of_connected_monitors()
{
	local list=( $(xrandr_list_connected_monitors) )

	echo ${#list[@]}
	

}


# @param monitor name
function xrandr_is_monitor_connected()
{

}


function xrandr_build_command()
{

	local _monitors_list=$(xrandr_list_connected_monitors)
	local command="xrandr "
 for monitor in $_monitors_list; do

 	#echo "set \$output${i} $monitor"
	
 	command="$command --output $monitor --auto "
 	if [ ! -z $previous_monitor ]; then
 		command="$command --right-of $previous_monitor"
 	fi
 	previous_monitor=$monitor

 	# care: blanks needed
 	i=$(expr $i + 1)
 done

echo "$command"

#eval "$command"
}

function i3_build_outputs_config()
{
	# without blank , greps also 'disconnected' monitors
	local _i=1
	local _monitors=('null' $(xrandr_list_connected_monitors) )


	# choose an upper born equal to the number of outputs expected in your i3 config
	local _main_output="${_monitors[1]}"
	local _output=$_main_output
	until [ $_i -gt 2 ]; do
		


		if [ -z "${_monitors[$_i]}" ]; then
			_output=$_main_output
		else
			_output=${_monitors[_i]}
			# last_connected_output=output
		fi

		echo "set \$output${_i} $_output"
		_i=$(expr $_i + 1 )
	done 

	if [ $? != "0" ]; then
		notify-send "Xrandr error"
		echo 'set $output1 LVDS'
		echo 'set $output2 LVDS1'
	fi

}


function is_a_number()
{
	echo "TODO"
}






# done 



#     if [$? -eq 0]; then
#         # External monitor is connected
#         xrandr --output VGA --mode 1280x1024 --pos 0x0 --output LVDS --mode 1400x1050 --pos 0x998
#         if [$? -ne 0]; then
#             # Something went wrong. Autoconfigure the internal monitor and disable the external one
#             xrandr --output LVDS --mode auto --output VGA --off
#         fi
#     else
#         # External monitor is not connected
#         xrandr --output LVDS --mode 1400x1050 --output VGA --off
#     fi

