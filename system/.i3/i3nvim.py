#!/usr/bin/python3
from neovim import attach
import argparse
import subprocess
import os
import traceback
import logging
import psutil


log = logging.getLogger(__name__)
# log.setLevel(logging.INFO)
log.setLevel(logging.DEBUG)

log.addHandler(logging.FileHandler("/home/teto/i3nvim.log", delay=False))

"""
Exit value:
0 => success
1 => failure
"""
directions = {
        'left' : 'h',
        'right' : "l",
        'up': 'k',
        'down': 'j',
}



def get_focused_window_name():
        try:
                out = subprocess.check_output("xdotool getwindowfocus getwindowname", shell=True).decode()
                return out
        except Exception as e:
                log.error(e)
        return ""


def get_nvim_socket():
        """
        1/ get pid of focused window
        2/ look for nvim processes in its children
        3/ search for socket name in the nvim child process
        """
        try:
                pid = subprocess.check_output("xdotool getwindowfocus getwindowpid", shell=True).decode()
                pid = pid.rstrip()
                pid = int(pid)
                log.debug("Retreived terminal pid %d, nvim should be one of its children" % pid)
                proc = psutil.Process( pid)
                log.debug( "proc name %s with %d children" % (proc.name(), len(proc.children(recursive=True))))
                for child in proc.children(recursive=True):
                        log.debug("child name & pid %s/%d" % (child.name(), child.pid))
                        if child.name() == "nvim":
                                unix_sockets = child.connections(kind="unix")
                                log.debug("Found an nvim subprocess with %d " % len(unix_sockets))
                                # look for socket 
                                # for filename, fd in child.open_files():
                                # log.debug("Open file %s " % filename)
                                for con in unix_sockets:
                                        filename = con.laddr
                                        log.debug("Socket %s " % filename)
                                        if "/tmp/nvim" in filename:
                                                log.debug("Found a match: %s" % filename) 
                                                return True, filename
                                return False, ""
        except Exception as e:
                log.error('Could not find neovim socket %s' % e)
                log.error(traceback.format_exc())
                return False, ""

        # instead of using psutil one could do sthg like:
        #  lsof -a -U -p 15684 -F n | grep /tmp/nvim |head -n1

def send_nvim_wincmd(path_to_socket, direction):
        log.info("Sending %s to socket %s" % (direction, path_to_socket))
        try:
                # path=os.environ["NVIM_LISTEN_ADDRESS"]
                # https://github.com/neovim/python-client/issues/124
                nvim = attach('socket', path=path_to_socket)
                log.debug("nvim attached")
                res= nvim.call('WinCmdWithRes', direction)
                log.debug("RPC call %d" % res)
                res = nvim.vars['wincmd_result']
                log.debug("Result of command %d" % res)
                return res
        except Exception as e:
                log.error("Exception %s" % e)
                exit(1)

        return False

def send_i3_cmd(direction):
        cmd = "i3-msg focus %s" % (direction)
        log.info("running command: %s" % cmd)
        os.system(cmd)

"""
Program starts here
"""
# TODO we can set NVIM_LISTEN_ADDRESS before hand
parser = argparse.ArgumentParser(description="parameter to send to wincmd")
parser.add_argument("direction", choices=directions.keys())
parser.add_argument("--test", action="store_const", const=True)

args = parser.parse_args()


name = get_focused_window_name().rstrip()
log.debug("Window name=%s" % name)
# if we are focusing neovim
if name.endswith("NVIM"):

        log.info("NVIM detected")
        res, socket = get_nvim_socket()

        if not res:
                log.error("Could not find vim socket")
        elif send_nvim_wincmd(socket, directions[args.direction]):
                log.debug("nvim changed its focus")
                # if neovim succeeded changing buffer 
                exit(0)
        else:
                log.debug("nvim did not change focus")

# if anything failed or nvim didn't change buffer focus, we forward the command o i3
send_i3_cmd(args.direction)
exit(0)
