#/usr/bin/env python3
from neovim import attach
import argparse
import subprocess
import os

"""
Exit value:
2 => exception
1 => success
0 => failure
"""
directions = {
        'h': 'left',
        'l': 'right',
        'k': 'up',
        'j': 'down'
}



def get_window_name():
        return subprocess.check_output("xdotool getwindowfocus getwindowname", shell=True).decode()

def get_nvim_socket():
        return '/tmp/nvimnT7Nor/0'
        # get pid and from pid look for socket
        # pid = subprocess.check_output("xdotool getwindowfocus getwindowpid", shell=True)
        # print(pid)

def send_nvim_wincmd(path_to_socket, direction):

        try:
                # path=os.environ["NVIM_LISTEN_ADDRESS"]
                # https://github.com/neovim/python-client/issues/124
                nvim = attach('socket', path=path_to_socket)
                res= nvim.call('WinCmdWithRes', args.direction)

        except Exception as e:
                print("Exception", e)
                exit(1)

def send_i3_cmd(direction):
        cmd = "i3-msg focus %s" % (direction)
        print("running command:\n%s" % cmd)
        os.system(cmd)

"""
Program starts here
"""
# TODO we can set NVIM_LISTEN_ADDRESS before hand
parser = argparse.ArgumentParser(description="parameter to send to wincmd")
parser.add_argument("direction", choices=directions.keys())

args = parser.parse_args()



# if we are focusing neovim
if get_window_name().endswith("NVIM"):
        socket = get_nvim_socket()
        if send_nvim_wincmd(socket, args.direction):
                exit(0)

send_i3_cmd(directions[args.direction])
exit(0)
