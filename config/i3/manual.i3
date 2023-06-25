#vim: set noet fdm=manual fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker:
# ##########################################
### MAIN
##########################################

#for_window [instance="audioplayer"] move to scratchpad
for_window [instance="pad_*"] move scratchpad

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


# Use mod-Control-Up and Down to rotate through the workspace list.
no_focus [class="^qutebrowser"]

bindsym $mod+F2 [instance="pad_(?!audioplayer)"] move scratchpad ; [instance="pad_audioplayer"] scratchpad show
bindsym $mod+F3 [instance="pad_(?!ncmpcpp)"] move scratchpad; [instance="pad_ncmpcpp"] scratchpad show


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

bindsym $mod+apostrophe mode "programs"


for_window [con_mark="^pad_*"] move scratchpad

# move to scratchpad
bindsym $mod+Shift+F1 mark "pad_1"
bindsym $mod+Shift+F2 floating toggle
bindsym $mod+Shift+F3 move container to workspace "$w3"
bindsym $mod+Shift+F4 move container to workspace "$w4"


set $rofi_mode rofi <b>Q</b>qutebrowser <b>b</b>uku
bindsym $mod+Shift+R mode "$rofi_mode"

mode --pango_markup "$rofi_mode" {
	# rofi -modi 'run,DRun,window,ssh,Layouts:i3-list-layouts,file:/home/teto/rofi/Examples/rofi-file-browser.sh' -show run
	bindsym w mode "default", exec rofi -modi 'window' -show
	# TODO use my patch
	bindsym q mode "default", exec rofi -modi 'window' -show
	# TODO to use with Qtpass

	bindsym Return mode "default"
	bindsym Escape mode "default"
}



bindsym $mod+shift+b border toggle
bindsym $mod+ctrl+minus move scratchpad

bindsym $mod+shift+p mode mouse

# bindsym Menu exec /nix/store/wdpmd24p4bdc8c3y63sjr5x272fxw0mx-i3easyfocus-20190411/bin/i3-easyfocus


mode mouse {

#xdotool mousemove --sync 1000 10
#xdotool click 3
	bindsym $mod+Left exec	$(xdotool mousemove_relative --sync -- -15 0)
	bindsym $mod+Right exec $(xdotool mousemove_relative --sync -- 15 0)
	bindsym $mod+Down exec  $(xdotool mousemove_relative --sync -- 0 15)
	bindsym $mod+Up   exec  $(xdotool mousemove_relative --sync -- 0 -15)
	bindsym Escape mode "default"
}

for_window [class="^qutebrowser$"] title_format "<span background='blue'>QB</span> %title"
for_window [class="^Firefox$"] title_format "<span background='#F28559'>FF</span> %title"
for_window [title="Thunderbird$"] title_format " %title"

# class
for_window [instance="pad_*"] move scratchpad
for_window [class="^firefox-nova$"] move workspace "5:misc"

