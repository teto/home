

### Start of config.mediakeys
bindsym XF86AudioStop exec {{ stop }}; {{notify("Music Paused") }}
bindsym XF86AudioPlay exec {{ play }}; {{notify(" Resuming music")}}
bindsym XF86AudioNext exec {{ next }}; {{notify("Next song")}}
bindsym XF86AudioPrev exec {{ prev }}; {{notify("Next song")}}