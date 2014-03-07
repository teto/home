#!/usr/bin/python3
# require jinja2 and python3-xlib
# Mako header
# from mako.template import Template
#from 
import jinja2 as j2
# import Environment, PackageLoader
import json,os
import xrandr
import sys

# on peut passer des trucs en parametre

monitors = xrandr.list_connected_monitors()

print( " monitors ", monitors )

# TODO match detected monitor to a configuration

# We need an output/bar (status/position/color) binding
# choisir 
def cb(msg):
    # os.system(msg)
    #
    return u"notify-send "+msg;

fp = open("config.json")
data= json.load(fp)

# print( json.dumps(data,sort_keys=True,indent=4, separators=(',', ': ')) )

# print( data["volume"]["alsa"])
# on peut aouter des object hook object_hook=
#, module_directory='/tmp/mako_modules'

# TODO autodetect screens
# TODO je peux faire ca
# {% for key, value in my_dict.iteritems() %}
# TODO associer a un workspace un output
# "modes" : [
#     { "bind" : "{{ mod }}+Shift+E", "name": "test"},
#     { "bind" : "{{ mod }}+Shift+E", "name": "test"}
# ]
    


homeScreen =   {
            "bar" :
            {
            "command" : "python3 ~/.i3/myStatus.py",
            "position" : "top",
            "theme" : "default"
            }
            ,
            "ws" : [
               # {
               #  "name" : "hello",
               #  "goto_ws" : "$mod+ampersand",
               #  "moveto_ws" : "$mod+Shift+ampersand"
               #  }
                ("hello","ampersand")
                
            ]
            #[  "1 main", "2 web","3 éditeurs", "4 qemu", "5 misc" ]

        }

workScreen = {
            "bar" :
            {
            "command" : "python3 ~/.i3/myStatus.py",
            "position" : "top",
            "theme" : "default"
            }
            ,
            "ws" : {} 
                # ( "$mod+eacute", "plop")
                
            #[  "1 main", "2 web","3 éditeurs", "4 qemu", "5 misc" ]

        }

monitors =  [
            homeScreen,
            workScreen
    ]

main = {
    "terminal" : "rxvt-unicode",
    # TODO proposer une conversion ici (Shift/Alt/Mod1/Win/ etc...)
    "modifier" : "Mod1",
    # "modes" : [],
    # LOad theme
    "theme" : "default",
    # ("theme/basic.tpl")
    # "bars" : [
    "ipc_socket" : "~/.i3/ipc.sock",    
    "mods" : [
                ("modes/resize.tpl",{}),
                ("keys/move_win.tpl",data["keys/move_win"]["arrows"]),
                ("keys/move_win.tpl",data["keys/move_win"]["jklm"]),
                ("keys/focus_win.tpl",data["keys/focus"]["arrows"]),

                 # ("keys/media.tpl", data["volume"]["alsa"]),
                 # ("macros/mediaplayer.tpl",data["players"]["ncmpcpp"])
                ]
}



#plugins["imports"]
env = j2.Environment(loader=j2.FileSystemLoader( "." ) )
# env.globals['notify'] = cb;
# notify = 
# debug un template ?
#config.mediakeys
# globals=

# parent c'est config.tpl
mainTpl = env.get_template('config.tpl')

# try:
# outputs, modifier, theme
main.update({ "outputs": monitors })
output= mainTpl.render(
            # volume= data["volume"]["alsa"], player=data["players"]["ncmpcpp"], screen=data["xbacklight"],notify=cb
                main
            )




# for tplFilename,conf in main["mods"]:
#     tpl = env.get_template(tplFilename,parent=mainTpl)
#     output += tpl.render(conf)


print ( output)

with open("config.test","w+") as f:
    f.write(output)

# faut des plugins pour shutdown
# passer une commande pour lancer le terminal ? -e -n ?
# class i3config:

#     def __init__(output):
#         pass

#     def generate
# except Exception as e:
#     print("Error : %s"%e.with_traceback() )

# MAKO version
# try:
#     mytemplate = Template(filename='config.mediakeys')
#     print( mytemplate.render( volume= data["volume"]["alsa"], player=data["players"]["ncmpcpp"],notify=cb ) )
# except Exception as e:
#     print("Error ",e)
