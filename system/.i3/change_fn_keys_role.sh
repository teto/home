#!/bin/bash

currentValue=$(cat /sys/module/hid_apple/parameters/fnmode)
#echo $currentValue
currentValue=$(( $currentValue + 1))
if [ $currentValue -gt 2 ]; then                                   
	currentValue=0;
fi

#echo $currentValue
echo $currentValue | sudo tee /sys/module/hid_apple/parameters/fnmode
notify-send "Current Value of FN $currentValue" 
