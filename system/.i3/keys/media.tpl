### Start of config.mediakeys
bindsym XF86AudioStop exec {{ stop }}; {{ notify("Music Paused") }}
bindsym XF86AudioPlay exec {{ play }}; {{notify(" Resuming music")}}
bindsym XF86AudioNext exec {{ next }}; {{notify("Next song")}}
bindsym XF86AudioPrev exec {{ player.prev }}; {{notify("Next song")}}


bindsym XF86AudioRaiseVolume exec {{volume.up}}; {{notify("Audio Raised volume") }}
bindsym XF86AudioLowerVolume exec {{volume.down}}; {{notify("Lowered volume to XXX") }}
bindsym XF86AudioMute exec {{volume.mute }}; {{notify("Mute") }}



### for backlight
bindsym XF86MonBrightnessUp exec {{ screen.lightup }};  {{notify("Light up") }}
bindsym XF86MonBrightnessDown exec {{ screen.lightdown }}; {{notify("Light down") }}

### end of config.mediakeys
