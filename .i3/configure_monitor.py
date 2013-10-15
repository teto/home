#!/usr/bin/python

import subprocess
import xrandr
from i3 import choose_via_dmenu

connected_monitors = xrandr.list_connected_monitors();

#print  "\n".join(connected_monitors) # | 
chosen_monitor= choose_via_dmenu( connected_monitors )
print ('stdout', chosen_monitor)
print ('connected monitors', len( connected_monitors ) )

actions= {
"Disable": "--output OUTPUT --off",
"Top":  "--above ",
"Left": "--left-of ",
"Right": "--right-of ",
"Bottom": "--below "
}

chosen_action= choose_via_dmenu(  actions.keys(),prompt=" Action ?" )
print( "my action", chosen_action)


reference_monitor=chosen_monitor

# just disable current monitor
if chosen_action == "Disable":
        command="xrandr --output "+chosen_monitor+" --off "
else:

        connected_monitors.remove( chosen_monitor );

        if len(connected_monitors) == 1:
                reference_monitor= connected_monitors[0];
        else:
                reference_monitor=choose_via_dmenu( connected_monitors )
                
        command="xrandr --output "+chosen_monitor+" "+actions[chosen_action]+" "+reference_monitor+ " --auto"

#actions[choice]
print ("command", command)
subprocess.call( command , shell=True );                             
xrandr.py                                 
