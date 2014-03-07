# TODO should detect the number of monitors !
bindsym {{enable_mode}}  mode "monitors"

mode "monitors" {
    
    bindsym {{output_left}} move workspace to output left; {{on_output_left|default("")}}
    bindsym {{output_right}} move workspace to output right;{{on_output_right|default("")}}
    bindsym {{output_up}} move workspace to output top
    bindsym {{output_down}} move workspace to output down
                
    bindsym $mod+Shift+Left workspace prev_on_output
    bindsym $mod+Shift+Right workspace next_on_output

    bindsym {{escape_mode}} mode "default"

}

