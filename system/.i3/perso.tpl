
focus_follows_mouse no
workspace_auto_back_and_forth yes

# TODO regen config file
# reload the configuration file
bindsym $mod+Shift+C reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+R exec "$HOME/.i3/build_config.sh"; restart
# exit i3 (logs you out of your X session)
# command is 'exit'
bindsym $mod+Shift+E exec "$HOME/.i3/logout.py"


bindsym $mod+ctrl+minus move scratchpad
exec_always urxvtc -name pad_audioplayer -e mocp
exec_always urxvtc -name pad_flyingterminal
exec_always urxvtc -name pad_cmus -e cmus
exec_always urxvtc -name pad_term4
exec_always urxvtc -name pad_term5

# move to scratchpad
bindsym $mod+Shift+F1 mark pad1; move scratchpad
bindsym $mod+Shift+F2 move container to workspace "$w2" 
bindsym $mod+Shift+F3 move container to workspace "$w3"
bindsym $mod+Shift+F4 move container to workspace "$w4"

# change container layout (stacked, tabbed, default)
bindsym $mod+s layout stacking
bindsym $mod+z layout tabbed
bindsym $mod+e layout default

# to lock screen
bindsym $mod+Ctrl+L exec "i3lock -i ~/Images/route66.png"

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+p focus parent
bindsym $mod+q exec nautilus --no-desktop

# focus the child container
#bindcode $mod+d focus child


# split in horizontal orientation
bindsym $mod+b split h

# split in vertical orientation
bindsym $mod+v split v
#bindsym $mod+v layout toggle split

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen



workspace "$w1" output $output1
workspace "$w2" output $output2
workspace "$w3" output $output2
workspace "$w4" output $output2
assign [class="^Firefox$"] $w2



#for_window [instance="audioplayer"] move to scratchpad
for_window [instance="pad_audioplayer"] move scratchpad
for_window [instance="pad_flyingterminal"] move scratchpad
for_window [instance="pad_ircclient"] move scratchpad
for_window [class="Navigator"] floating enable,border 1 pixel;


# Manage monitors, enable or disable
bindsym $mod+Shift+V exec "$HOME/.i3/manage_monitors.sh"



#bindsym $mod+F1 exec urxvt -name ranger -e ranger



# TODO remove since it is used by Dunst ?

bindsym $mod+c exec "~/.i3/misc_commands.py"





# Go into hibernation
#bindsym Mod4+Shift+F9 exec sudo hibernate -F /etc/hibernate/tuxonice.conf



# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec --no-startup-id $term
bindsym $mod+Shift+Return exec --no-startup-id ~/.i3/fork_term.sh




# kill focused window
bindsym $mod+Shift+A kill

# start dmenu (a program launcher)
bindsym $mod+d exec j4-dmenu-desktop
#dmenu_run -

#for_window [title="MOC"] move scratchpad
for_window [Class="^Transmission"] floating enable
bindsym $mod+F2 [instance="pad_(?!audioplayer)"] move scratchpad ; [instance="pad_audioplayer"] scratchpad show
#i3-msg [con_marki=pad1] focus
bindsym $mod+F1 [instance="pad_(?!flyingterminal)"] move scratchpad; [instance="pad_flyingterminal"] scratchpad show
#bindsym $mod+F3 scratchpad show


