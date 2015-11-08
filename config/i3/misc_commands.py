#!/usr/bin/python
NOTIFY="notify-send"

#virsh vcpu pin
if [ $# -ne 1 ]; then
	$NOTIFY "Use: $0 <action>"
	exit 1
fi


FX_MODE=2
MAC_MODE=1

action=$1

$NOTIFY "Launching action '$action'"

def get_touchpad_state()
{
	res=$(synclient | grep TouchpadOff |cut -d= -f2)
	echo $res
}


""" create a """
def enable_fnkeys(enable):
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


def set_touchpad(enable):
	i3.run("synclient TouchpadOff=$newValue")
	i3.notify( "Setting touchpad to $newValue")


# according to first char, set,inc or dec
# + / - / =
def set_light():
	pass

actions = {
"Enable touchpad" : set_touchpad(True),
"Disable touchpad" : set_touchpad(False),
}


try;
	i3.choose_via_dmenu( actions )
except Exception as e:
	print("No choice made")
	exit(1)

exit(0)



