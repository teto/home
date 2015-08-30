# vim: set foldmethod=marker:

# XDG configuration {{{
# Specs here:
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
# $XDG_DATA_HOME defines the base directory relative to which user specific data files should be stored. By default equal to $HOME/.local/share.
export XDG_DATA_HOME="$HOME/.local/share"
# $XDG_CONFIG_HOME defines the base directory relative to which user specific configuration files should be stored. By default equal to $HOME/.config should be used. 
export XDG_CONFIG_HOME="$HOME/.config"

#$XDG_CACHE_HOME defines the base directory relative to which user specific non-essential data files should be stored. By default "$HOME/.cache"
export XDG_CACHE_HOME="$HOME/.cache"
# }}}

# PATH {{{
#PATH="/usr/lib/w3m:$PATH"
#PATH="$PATH:/home/teto/csvfix/csvfix/bin"
PATH="$PATH:/home/teto/powerline/scripts"

# set PATH so it includes user's private bin if it  exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
#echo $PATH
export PATH
# }}}

# PYTHONPATH {{{
PYTHONPATH="$PYTHONPATH:$HOME/i3pystatus"
pYTHONPATH="$PYTHONPATH:$HOME/powerline"
PYTHONPATH="$PYTHONPATH:$HOME/i3gen"
PYTHONPATH="$PYTHONPATH:$HOME/analyzer"
PYTHONPATH="$PYTHONPATH:$HOME/python-keyring-lib"
PYTHONPATH="$PYTHONPATH:$HOME/i3ipc-python"
#PYTHONPATH="$PYTHONPATH:/home/teto/mptcpanalyzer"
PYTHONPATH="/home/teto/powerline:$PYTHONPATH"
export PYTHONPATH
# }}}

export VAGRANT_DEFAULT_PROVIDER="libvirt"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"


#export ZDOTDIR="$HOME/.zsh"

export MAILDIR="$HOME/Maildir" 
export MUTT="$HOME/.mutt"

export EDITOR="nvim"
export TERMINAL="urxvt"


# for DCE/ns3 experiments {{{
DCE_PATH="$HOME/mptcpoff" # for liblinux.so
DCE_PATH="$DCE_PATH:$HOME/iproute2/ip" # for 'ip' program
DCE_PATH="$DCE_PATH:$HOME/iperf-2.0.5/src" # for 'iperf' program
export DCE_PATH

export DCE_FOLDER="$HOME/dce"
export NS3_FOLDER="$HOME/ns3off"
# }}}
