#!/usr/bin/env python

# Copyright (c) 2013 Artem Shinkarov <artyom.shinkaroff@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import i3
import shlex
from subprocess import Popen, PIPE

l_reboot =   "Reboot   (r)"
l_shutdown = "Shutdown (s)"
l_logout =   "Logout   (l)"
l_cancel =   "Cancel   (c)"
 

def get_resolution (ws):
    for w in ws:
        if w["focused"] and w["visible"]:
            return w["rect"]
    raise Exception ("no active workspaces o_O")

def exec_dzen (rect):
    x = rect["x"]
    y = rect["y"]
    height = rect["height"]
    width = rect["width"]
    
    b_reboot = l_reboot
    b_shutdown = l_shutdown
    b_logout = l_logout
    b_cancel = l_cancel
   
    menu_width = 200
    menu_lines = 4
    font_width = 16
    menu_x = x + width/2 - menu_width/2
    menu_y = y + height/2 - menu_lines * font_width /2

    font_header = "-*-fixed-medium-*-*-*-11-*-*-*-*-*-*-*"
    font_menu =   "-*-fixed-bold-*-*-*-11-*-*-*-*-*-*-*"
    
    onstart = "onstart=uncollapse,grabkeys"
    button1 = "button1=ungrabkeys,menuprint,exit"
    escape =  "key_Escape=exit"
    keyq =    "key_q=exit"
    keyQ =    "key_Q=exit"
    keyr =    "key_r=ungrabkeys,print:%(b_reboot)s,exit"
    keyR =    "key_R=ungrabkeys,print:%(b_reboot)s,exit"
    keyl =    "key_l=ungrabkeys,print:%(b_logout)s,exit"
    keyL =    "key_L=ungrabkeys,print:%(b_logout)s,exit"
    keys =    "key_s=ungrabkeys,print:%(b_shutdown)s,exit"
    keyS =    "key_S=ungrabkeys,print:%(b_shutdown)s,exit"
    keyc =    "key_c=ungrabkeys,print:%(b_cancel)s,exit"
    keyC =    "key_C=ungrabkeys,print:%(b_cancel)s,exit"

    cmd = "/home/tema/src/dzen/dzen2 -p -m -l %(menu_lines)i -x %(menu_x)i -y %(menu_y)i " +\
          "-w %(menu_width)i -sa c -fn %(font_menu)s -bg \"#151515\" -fg \"#92cd00\" " + \
          "-e \"" + ";".join ((onstart, button1,escape,keyq,keyQ,keyr,keyR, \
                               keyl,keyL,keys,keyS,keyc,keyC)) +\
          "\""
    cmd = cmd % locals ()
    args = shlex.split (cmd);

    p = Popen (args, stdin=PIPE, stdout=PIPE)
    
    msg = "^fg(#ff9000)^fn(%(font_header)s) Shutdown options / [Esc] ^fg()" + \
          "\n%(b_shutdown)s\n%(b_reboot)s\n%(b_logout)s\n%(b_cancel)s"
    msg = msg % locals ()
    print >>p.stdin, msg
    p.stdin.close ()
    
    res = p.stdout.readlines ()
    p.stdout.close ()
    if res == []:
        return ""
    else:
        return res[0].strip ()

def action (cmd):
    if cmd == l_reboot:
        cmd = "sudo shutdown -r now"
    elif cmd == l_shutdown:
        cmd = "sudo shutdown -h now"
    elif cmd == l_logout:
        cmd = "i3-msg exit"
    else:
        return

    args = shlex.split (cmd)
    Popen  (args)

if __name__ == "__main__":
    ws = i3.get_workspaces ()
    res = get_resolution (ws)
    a = exec_dzen (res)
    action (a)
