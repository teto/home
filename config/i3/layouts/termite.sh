#!/bin/sh

i3-msg "append_layout $(basename $0)/.json"

termite -d "$HOME/dotfiles" -r "toto" &
termite -r "caca"& 

#i3-msg "workspace 9; append_layout /home/teto/.i3/ws1.json"

##urxvt -e sh -c "cd $HOME/ns3off;$SHELL" &
#urxvt -cd $HOME/ns3off&

#urxvt -e sh -c "cd $HOME/neovim;$SHELL"&
#urxvt -e sh -c "$SHELL"&
##urxvt -e sh -c "cd $HOME/dce;$SHELL" &
#urxvt -name DCE -cd $HOME/dce&
