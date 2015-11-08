#!/usr/bin/env python3

# https://faq.i3wm.org/question/3699/how-can-i-open-an-application-when-i-open-a-certain-workspace-for-the-first-time/

from argparse import ArgumentParser
import i3ipc

i3 = i3ipc.Connection()

parser = ArgumentParser(description='Open an application on a given workspace when it is initialized')

parser.add_argument('--unmark', action="store_true",  help='The name of the workspace')
#parser.add_argument('--command', metavar='CMD', help='The command to run on the newly initted workspace')

args = parser.parse_args()

#def on_workspace(i3, e):
    #if e.current.props.name == args.workspace and not len(e.current.leaves()):
        #i3.command('exec {}'.format(args.command))



def get_current_workspace_leaves():

    ws_list = i3.get_workspaces()

    for ws in ws_list:
        if ws['focused'] == True:
            ws_focused = ws
            break

    if not ws_focused:
        raise Exception("Focused ws not found")

    print(ws_focused, dir(ws_focused))

#'i3ipc.WorkspaceReply'
#print("name ", ws_focused.get_name() )
    print("Leaves", type(ws_focused), ) #  ws_focused.leaves() )

    leaves = i3.get_tree().leaves()
#print(tree, dir(tree))


    ws_leaves = []
    for c in leaves:
        print(c.name)
        if (c.workspace().name) == ws_focused.name:
            ws_leaves.append(c)

    return ws_leaves

#print( ws_leaves)
ws_leaves = get_current_workspace_leaves()

for i,c in enumerate(ws_leaves):
    if args.unmark:
        c.command("unmark")
    else:
        c.command("mark %c" % chr(ord('a')+i))
#print(leaves)
#Win Mod4



#i3.on('workspace::focus', on_workspace)

#i3.main()
