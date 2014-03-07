{%macro window_colors() %}
#########################################
### config.colors
#########################################
# class                 border  backgrd text   indicator
client.focused          #d72f6b #d70a53 #FFFF50 #FFFF50
client.focused_inactive #06090d #06090d #696f89 #090e14
client.unfocused        #090e14 #090e14 #696f89 #090e14
client.urgent           #870000 #870000 #ffffff #090e14
client.background       #06090d

hide_edge_borders both  
# font for window titles. ISO 10646 = Unicode
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

# default border size
#new_window 1pixel
new_float pixel 2

# font for window titles
font xft:Liberation Sans Mono 8
{% endmacro %}


{%macro add_bar(config) %}

bar {
    position {{ config.position|default("top") }}
    status_command {{ config.command|default("i3bar") }}

    {% for output in config.outputs|default([]) %}
    output {{output}}
    {%- endfor %}

    {% include colors %}
    colors {
        background #090e14
        statusline #ffffff

        # class            border  backgrd text
        focused_workspace  #d72f6b #d70a53 #FFFF50
        active_workspace   #06090d #06090d #696f89
        inactive_workspace #06090d #06090d #696f89
        urgent_workspace   #d72f6b #d70a53 #FFFF50                                    
    }

{% endmacro %}