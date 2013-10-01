#!/usr/bin/python
import subprocess
import xrandr


def notify(title, message):
	subprocess.call("notify-send");


def choose_via_dmenu( cmd_line, items ):                             
        
        stdin=subprocess.PIPE 
        p = subprocess.Popen( "dmenu", stdin=subprocess.PIPE , stdout = subprocess.PIPE, stderr=subprocess.PIPE  );
        stdoutdata, stderrdata = p.communicate("\n".join( items ))
        return stdoutdata




