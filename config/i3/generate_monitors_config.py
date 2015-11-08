#!/usr/bin/python3

import xrandr as x
import sys
import logging
import argparse
# because map function in python3 stops to shortest list
from itertools import zip_longest, starmap


monitors = []
monitors = x.list_connected_monitors( )

log = logging.getLogger()

if len(sys.argv) < 2:
	log.error("Usage: {name} <outputFilename>".format(name=sys.argv[0]) )
	exit(1);



#def createTuple(id):
	#print("createTuple",id)
	#return (id, monitors[0])
	##return (id, monitor if monitor else monitors[0])


#def createTuple2(id, mon):
	#print("ID",id)
	#if mon:
		#return (id,mon)
	#else:
		#return (id, monitors[0])

try:
	outputFile=sys.argv[1]
	log.info("OutputFile [%s]"%outputFile)
	cmd=x.build_xrandr_command(monitors)
	with open(outputFile,"w+") as f:
		f.write("########################\n ###  %s \n###################\n"%outputFile)
		#f.write("exec_always %s\n"%cmd)
		monitors2 = starmap( lambda id,mon: (id, mon if mon else monitors[0]), zip_longest(  range(1,3),  monitors ) )
		for i,monitorName in monitors2: 
			#print(i, monitorName)
			f.write("set $output%d '%s'\n"%(i,monitorName) )

		#print("i %d"%i)
        # f.write(" '%s'"%cmd)


except Exception as e:
	log.fatal("Exception: %s"%e);
#.with_traceback())

# "$folder/config.monitors"
# print(cmd)
