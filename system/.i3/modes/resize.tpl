# resize window (you can also use the mouse for that)
mode "resize" {

    # Pressing right will grow the window’s width.
    # Pressing up will shrink the window’s height.
    # Pressing down will grow the window’s height.
    bindsym j resize grow left 10 px or 10 ppt
    bindsym Shift+j resize shrink left 10 px or 10 ppt

    bindsym Shift+k resize shrink up 10 px or 10 ppt

    bindsym l resize grow down 10 px or 10 ppt
    bindsym Shift+l resize shrink down 10 px or 10 ppt

    bindsym m resize grow right 10 px or 10 ppt
    bindsym Shift+m resize shrink right 10 px or 10 ppt

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
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
                                                                                      
bindsym $mod+r mode "resize"
