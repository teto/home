#!/bin/sh

i3-msg "workspace 9; append_layout $HOME/.i3/test.json"

urxvt -cd $HOME/dce &

#i3-msg "workspace 9; append_layout /home/teto/.i3/ws1.json"

##urxvt -e sh -c "cd $HOME/ns3off;$SHELL" &
#urxvt -cd $HOME/ns3off&

#urxvt -e sh -c "cd $HOME/neovim;$SHELL"&
#urxvt -e sh -c "$SHELL"&
##urxvt -e sh -c "cd $HOME/dce;$SHELL" &
#urxvt -name DCE -cd $HOME/dce&
