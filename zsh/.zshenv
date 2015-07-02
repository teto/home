PATH="/usr/lib/w3m:$PATH"
PATH="$PATH:/home/teto/csvfix/csvfix/bin"
PATH="$PATH:/home/teto/powerline/scripts"

# set PATH so it includes user's private bin if it  exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
echo $PATH
export PATH


PYTHONPATH="$PYTHONPATH:$HOME/i3pystatus"
pYTHONPATH="$PYTHONPATH:$HOME/powerline"
PYTHONPATH="$PYTHONPATH:$HOME/i3gen"
PYTHONPATH="$PYTHONPATH:$HOME/analyzer"
PYTHONPATH="$PYTHONPATH:$HOME/python-keyring-lib"
PYTHONPATH="$PYTHONPATH:$HOME/i3ipc-python"
#PYTHONPATH="$PYTHONPATH:/home/teto/mptcpanalyzer"
PYTHONPATH="/home/teto/powerline:$PYTHONPATH"
export PYTHONPATH

export VAGRANT_DEFAULT_PROVIDER="libvirt"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"


export ZDOTDIR="$HOME/.zsh"

export MAILDIR="$HOME/Maildir" 
export MUTT="$HOME/.mutt"

export EDITOR="vim"
export TERMINAL="urxvt"


export XDG_DATA_HOME="$HOME/.local"
