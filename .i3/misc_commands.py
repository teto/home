#!/usr/bin/python
NOTIFY="notify-send"

#virsh vcpu pin
if [ $# -ne 1 ]; then
	$NOTIFY "Use: $0 <action>"
	exit 1
fi

action=$1

$NOTIFY "Launching action '$action'"

function get_touchpad_state()
{
	res=$(synclient | grep TouchpadOff |cut -d= -f2)
	echo $res
}

case $action in

	"touchpad")
		res=$(get_touchpad_state)
		newValue=0;
		if [ $res -eq 0 ]; then
			newValue=1
		fi
		synclient TouchpadOff=$newValue
		$NOTIFY -c device "Setting touchpad to $newValue"
		;;

	"fn_keys")
		file="/sys/module/hid_apple/parameters/fnmode"
		currentValue=$(cat file )
		#echo $currentValue
		currentValue=$(( currentValue + 1))
		if [ $currentValue -gt 2 ]; then
			currentValue=0;
		fi

		#echo $currentValue
		gksu echo $currentValue >> "$file"
		$(NOTIFY "Current Value of FN $currentValue")
		;;

	# swap screens
	"swap") 
		;;

	default)
		$(NOTIFY "Unknown value")
		;;

esac

$(NOTIFY "script finished")
exit 0	
