#!/usr/bin/python3.4
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

log.addHandler(logging.FileHandler(os.path.join(os.getenv("HOME","") , "i3nvim.log"), delay=False))

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



def thunderbird_dispatcher(direction):
        if direction == 'right':
                key = "Ctrl+Tab"
        elif direction == 'left':
                key = "Ctrl+Shift+Tab"
        else:
                return False
        cmd = "xdotool search '{name}' key '{key}'".format(
                name=get_focused_window_name(),
                key=key,
        )
        log.debug('Launching command %s' % cmd)
        os.system(cmd)
        return True

def weechat_dispatcher(direction):
        if direction == 'right':
                key = "F5"
        elif direction == 'left':
                key = "F6"
        else:
                return False
        cmd = "xdotool key {key}".format(
                # name=get_focused_window_name(),
                key=key,
        )
        log.debug('Launching command %s' % cmd)
        os.system(cmd)
        return True


def nvim_dispatcher(direction):
        print("TRIDI")
        log.info("NVIM detected")
        res, socket = get_nvim_socket()

        if not res:
                log.error("Could not find vim socket")
        elif send_nvim_wincmd(socket, directions[direction]):
                log.debug("nvim changed its focus")
                # if neovim succeeded changing buffer 
                return True
        else:
                log.debug("nvim did not change focus")
        return False

def get_dispatcher():
        name = get_focused_window_name()
        log.debug("Window name=%s" % name)
# if we are focusing neovim
        if name.endswith("NVIM"):
                return nvim_dispatcher
        elif name.startswith("matt@"):
                return weechat_dispatcher
        elif name.endswith("Thunderbird"):
                return thunderbird_dispatcher
        
        return i3_dispatcher

def get_focused_window_name():
        try:
                out = subprocess.check_output("xdotool getwindowfocus getwindowname", shell=True).decode('utf-8').rstrip()
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
        # lsof -a -U -p 15684 -F n | grep /tmp/nvim |head -n1

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

def i3_dispatcher(direction):
        cmd = "i3-msg focus %s" % (direction)
        log.info("running command: %s" % cmd)
        os.system(cmd)
        return True

"""
Program starts here
"""
# TODO we can set NVIM_LISTEN_ADDRESS before hand
parser = argparse.ArgumentParser(description="parameter to send to wincmd")
parser.add_argument("direction", choices=directions.keys())
parser.add_argument("--test", action="store_const", const=True)

args = parser.parse_args()

"""
get dispatcher function
"""
dispatcher = get_dispatcher()

log.info("Calling dispatcher %r with direction %s" % (dispatcher, args.direction))
# dispatcher("toto")
# if anything failed or nvim didn't change buffer focus, we forward the command o i3
if not dispatcher(args.direction):
        i3_dispatcher(args.direction)
exit(0)
