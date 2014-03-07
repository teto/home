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

bindsym $mod+n mode "focused"