this configuration should launch mpd as a user instance.

Errors may appear if you  have not created the necessary files:
touch ~/.config/mpd/{database,log,pid,state,sticker.sql}

TODO: create them with a git hook
