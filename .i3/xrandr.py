#!/usr/bin/python3
import subprocess
# import re 
 
positions = {
"1920x1080": "--above", # Monitor
"1360x768": "--below" # TV
}


# set first as primary and others right of 1st one
def build_xrandr_command( monitors ):

	main_monitor = monitors[0]
	command="xrandr --output " + main_monitor +" --auto "
	for monitor in monitors[1:]:
		command+="--output "+monitor+" --right-of "+ main_monitor + " --auto ";

	return command	




def list_connected_monitors(): 

	output = subprocess.check_output("xrandr", shell=True).decode("utf-8")
	 
	connected_monitors= []
	#external_connected=resolution=False
	for line in output.split("\n"):
		# CARE keep the space otherwise disconnected returns true as well
		if " connected" in line:
			connected_monitors.append(line.split()[0]) 
	return connected_monitors

