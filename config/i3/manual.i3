#  vim: set noet fdm=manual fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker:
# vim:filetype=i3
# ##########################################
### MAIN
##########################################


# default border size
#new_window  pixel 2
# title_window_icon yes
# enable window icons for all windows
# for_window [all] title_window_icon on
for_window [class="^Firefox$"] title_window_icon on

#for_window [instance="audioplayer"] move to scratchpad
for_window [instance="pad_*"] move scratchpad
#for_window [instance="pad_flyingterminal"] move scratchpad
#for_window [instance="pad_ircclient"] move scratchpad
# this concerns too many boxes, thus creating bugs

mode "focused" {

	# hardcoded focus keybindings
	bindsym b [class="(?i)firefox"] focus; mode "default"
	bindsym w [class="(?i)terminal" title="weechat"] focus
	bindsym m [class="(?i)thunderbird"] focus
	bindsym f [class="(?i)terminal" title="mc"] focus
	bindsym z [class="(?i)zathura"] focus

	# keybindings for marking and jumping to clients
	bindsym a exec i3-input -F 'mark %s' -P 'Mark name: '
	bindsym g exec i3-input -F '[con_mark=%s] focus' -P 'Go to mark: '

	# Assign marks to keys 1-5
	bindsym Shift+1 mark mark1
	bindsym Shift+2 mark mark2
	bindsym Shift+3 mark mark3
	bindsym Shift+4 mark mark4
	bindsym Shift+5 mark mark5

	# Jump to clients marked 1-5
	bindsym 1 [con_mark="mark1"] focus
	bindsym 2 [con_mark="mark2"] focus
	bindsym 3 [con_mark="mark3"] focus
	bindsym 4 [con_mark="mark4"] focus
	bindsym 5 [con_mark="mark5"] focus

	# Exit to the default mode
	bindsym Return mode "default"
	bindsym Escape mode "default"
}

# TODO remove since it is used by Dunst ?
bindsym $mod+n mode "focused"


# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod



# Use mod-Control-Up and Down to rotate through the workspace list.
no_focus [class="^qutebrowser"]

#for_window [title="MOC"] move scratchpad
#for_window [Class="^Transmission"] floating enable
#bindsym $mod+F1 [instance="pad_(?!flyingterminal)"] move scratchpad; [instance="pad_flyingterminal"] scratchpad show
#bindsym $mod+F2 [instance="pad_(?!audioplayer)"] move scratchpad ; [instance="pad_audioplayer"] scratchpad show
#bindsym $mod+F3 [instance="pad_(?!ncmpcpp)"] move scratchpad; [instance="pad_ncmpcpp"] scratchpad show
bindsym $mod+F1 [con_mark="pad_1"] scratchpad show
bindsym $mod+F2 [instance="pad_(?!audioplayer)"] move scratchpad ; [instance="pad_audioplayer"] scratchpad show
bindsym $mod+F3 [instance="pad_(?!ncmpcpp)"] move scratchpad; [instance="pad_ncmpcpp"] scratchpad show


# This may be slow since script involves a few steps
# change focus
bindsym $mod+$kleft focus left
bindsym $mod+$kdown focus down
bindsym $mod+$kup focus up
bindsym $mod+$kright focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
# bindsym $mod+b split h

# split in vertical orientation
# needs i3next
bindsym $mod+v split toggle

# enter fullscreen mode for the focused container
# bindsym $mod+f fullscreen
# bindsym $mod+Shift+f fullscreen global



# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle


mode "programs" {

    bindsym q exec "qutebrowser"; mode default
    bindsym f exec "firefox"; mode default
    bindsym c exec "codeblocks"; mode default
    bindsym m exec "mendeleydesktop"; mode default
    bindsym n exec "nemo"; mode default
    bindsym w exec "wireshark"; mode default
    bindsym z exec "zathura"; mode default

# set monitors, wap them ? etc..
    bindsym $mod+apostrophe mode "default"
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# bindsym $mod+quotedbl  focus child
#bindsym $mod+quotedbl workspace "$w3"
bindsym $mod+apostrophe mode "programs"

#bindsym $mod+q exec nemo
# focus the child container

for_window [con_mark="^pad_*"] move scratchpad

# move to scratchpad
bindsym $mod+Shift+F1 mark "pad_1"
bindsym $mod+Shift+F2 floating toggle
bindsym $mod+Shift+F3 move container to workspace "$w3"
bindsym $mod+Shift+F4 move container to workspace "$w4"


# bindsym $mod+Shift+E exec "$HOME/.i3/logout.py"


set $rofi_mode rofi <b>Q</b>qutebrowser <b>b</b>uku
bindsym $mod+Shift+R mode "$rofi_mode"
#
mode --pango_markup "$rofi_mode" {
	# rofi -modi 'run,DRun,window,ssh,Layouts:i3-list-layouts,file:/home/teto/rofi/Examples/rofi-file-browser.sh' -show run
	bindsym w mode "default", exec rofi -modi 'window' -show
	# TODO use my patch
	bindsym q mode "default", exec rofi -modi 'window' -show
	# TODO to use with Qtpass

	bindsym Return mode "default"
	bindsym Escape mode "default"
}

# resize window (you can also use the mouse for that) {{{
bindsym $mod+r mode "resize"
mode "resize" {

       # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize grow left 10 px or 10 ppt
        bindsym Shift+j resize shrink left 10 px or 10 ppt

        bindsym k resize grow up  10 px or 10 ppt
        bindsym Shift+k resize shrink up 10 px or 10 ppt

        bindsym l resize grow down 10 px or 10 ppt
        bindsym Shift+l resize shrink down 10 px or 10 ppt

        bindsym $GroupFr+m resize grow right 10 px or 10 ppt
        bindsym $GroupFr+Shift+m resize shrink right 10 px or 10 ppt

		# semicolumn is not recognized by sway
        # bindsym $GroupUs+semicolumn resize grow right 10 px or 10 ppt
        # bindsym $GroupUs+Shift+semicolumn resize shrink right 10 px or 10 ppt

        # same bindings, but for the arrow keys
        #bindsym Right resize shrink width 10 px or 10 ppt
        #bindsym Up resize grow height 10 px or 10 ppt
        #bindsym Down resize shrink height 10 px or 10 ppt
        #bindsym Left resize grow width 10 px or 10 ppt
        bindsym Left resize grow left 10 px or 10 ppt
        bindsym Shift+Left resize shrink left 10 px or 10 ppt

        bindsym Up resize shrink up  10 px or 10 ppt
        bindsym Shift+Up resize grow up 10 px or 10 ppt

        bindsym Down resize grow down 10 px or 10 ppt
        bindsym Shift+Down resize shrink down 10 px or 10 ppt

        bindsym Right resize grow right 10 px or 10 ppt
        bindsym Shift+Right resize shrink right 10 px or 10 ppt



	# back to normal: Enter or Escape
        bindsym $mod+r mode "default"
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
# }}}


bindsym $mod+shift+b border toggle
bindsym $mod+ctrl+minus move scratchpad

# bindsym $mod+shift+n exec nemo
bindsym $mod+shift+p mode mouse


mode mouse {

#xdotool mousemove --sync 1000 10
#xdotool click 3
	bindsym $mod+Left exec	$(xdotool mousemove_relative --sync -- -15 0)
	bindsym $mod+Right exec $(xdotool mousemove_relative --sync -- 15 0)
	bindsym $mod+Down exec  $(xdotool mousemove_relative --sync -- 0 15)
	bindsym $mod+Up   exec  $(xdotool mousemove_relative --sync -- 0 -15)
	bindsym Escape mode "default"
}

no_focus [window_role="pop-up"]

### TODO need to run urxvtd beforehand
### display error in case it does not launch
# Provide command to send to a specific scratchpad (rename title) or use mark ?
#
#exec_always urxvtc -name pad_audioplayer -e "mocp; $SHELL";
#exec_always urxvtc -name pad_flyingterminal
#exec_always urxvtc -name pad_ncmpcpp -e sh ncmpcpp;$SHELL
#exec_always urxvtc -name pad_term4
#exec_always urxvtc -name pad_term5

# xrandr --output LVDS1 --primary --auto --output DP1 --auto --right-of LVDS1
#exec_always xrandr --output $output1 --auto --output $output2 --right-of $output1
include ~/.config/i3/config.xp

exec_always --no-startup-id setxkbmap -layout us

