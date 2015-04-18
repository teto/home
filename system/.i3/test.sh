#!/bin/sh

i3-msg "workspace 9; append_layout /home/teto/.i3/ws1.json"


urxvt -e sh -c "cd neovim;$SHELL"
urxvt -e sh -c "$SHELL"
urxvt -e sh -c "cd ns3off;$SHELL"
urxvt -e sh -c "cd dce;$SHELL"
