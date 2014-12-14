export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.config"
#export XDG_RUNTIME_DIR="$HOME/.config"
#export XDG_DATA_HOME="$HOME/.config"

#export PYTHONPATH="/home/teto/libnl/python/build/lib.linux-x86_64-3.3:$PYTHONPATH"
export PYTHONPATH="/home/teto/libnlofficiel/python/build/lib.linux-x86_64-3.3:$PYTHONPATH"
#export PYTHONPATH="/home/teto/powerline:$PYTHONPATH"
export PATH="$PATH:/home/teto/csvfix/csvfix/bin"
export PATH="$PATH:/home/teto/powerline/scripts"
export MAILDIR="$HOME/Maildir"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

