
### for backlight
bindsym XF86MonBrightnessUp exec {{ screen.lightup }};  {{notify("Light up") |e -}}
bindsym XF86MonBrightnessDown exec {{ screen.lightdown }}; {{notify("Light down") |e -}}
