./configure --enable-timings --enable-drun
git submodule update --init


# add a mode

rofi -modi "window,run,ssh,Workspaces:i3_switch_workspaces.sh" -show Workspaces
y


