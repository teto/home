# vim: set foldmethod=marker:
# See https://wiki.archlinux.org/index.php/XDG_Base_Directory_support#Partial to get aound
#  non XDG conformant programs

# PATH {{{
#PATH="/usr/lib/w3m:$PATH"
#PATH="$PATH:/home/teto/csvfix/csvfix/bin"
PATH="$PATH:/home/teto/powerline/scripts"
PATH="$PATH:/home/teto/mptcpanalyzer"
PATH="$PATH:$HOME/.local/bin"
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

export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

export MAILDIR="$HOME/Maildir" 
export MUTT="$XDG_CONFIG_HOME/mutt"

export EDITOR="nvim"
export TERMINAL="urxvt"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"



# for DCE/ns3 experiments {{{
DCE_PATH="$HOME/mptcpoff" # for liblinux.so
DCE_PATH="$DCE_PATH:$HOME/iproute2/ip" # for 'ip' program
DCE_PATH="$DCE_PATH:$HOME/iperf3/src" # for 'iperf3' program
#DCE_PATH="$DCE_PATH:$HOME/iperf-2.0.5/src" # for 'iperf' program
DCE_PATH="$DCE_PATH:$HOME/iperf2/src" # for 'iperf' program
export DCE_PATH

export DCE_FOLDER="$HOME/dce"
export NS3_FOLDER="$HOME/ns3off"
# }}}
