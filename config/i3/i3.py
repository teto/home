#!/usr/bin/python
import subprocess
import os
import xrandr
from functools import partial


# urgency / category
def notify(message):
	#subprocess.call("notify-send");
	os.system("notify-send "+ str(message) );

def run_cmd(cmd):
	os.system(cmd)

def run(cmd):
	os.system(cmd)


dmenu_options = {
'prompt' : '-p %s',
'lines': '-l %d'

}



""" 
entries should be a callback 
if repop set to true, it will restart dmenu until pressing q
dmenu returns 1 when closed with escape, 0 if called with enter
 """
def choose_via_dmenu( entries,  **kwargs ):

	ret = 0
	stdin=subprocess.PIPE 

	# TODO build dmenu command promt,lines
	for option,cmd in dmenu_options.items():
		print("option presebt ?", kwargs.get(option ) )
	# if we get a list , we transform it into a callback
	#zip(
	if isinstance(entries,list):
		#dmenuInput = "\n".join( entries ) 
		entries = dict(  map( lambda x: ( x,x) , entries ) )
	elif not isinstance(entries,dict):
		raise ValueError("First argument should be either a list or dict")

		#dmenuInput = "\n".join( entries.keys() ) 

#	while ret == 0:
	p = subprocess.Popen( "dmenu", stdin=subprocess.PIPE , stdout = subprocess.PIPE, stderr=subprocess.PIPE  );

	# returns at the end of 
	stdoutdata, stderrdata = p.communicate("\n".join( entries.keys() ) )
	ret = p.returncode
	if ret:
		print("unusual quit")
		raise Exception("Nothing chosen")
	return entries[ stdoutdata ]
#	return stdoutdata


if __name__ == '__main__':
	print("hello world");
	# run some test


