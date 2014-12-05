# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# specs are here
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.config"
#export XDG_RUNTIME_DIR="$HOME/.config"
#export XDG_DATA_HOME="$HOME/.config"

#export PYTHONPATH="/home/teto/libnl/python/build/lib.linux-x86_64-3.3:$PYTHONPATH"
export PYTHONPATH="/home/teto/libnlofficiel/python/build/lib.linux-x86_64-3.3:$PYTHONPATH"
#export PYTHONPATH="/home/teto/powerline:$PYTHONPATH"
export PATH="$PATH:/home/teto/csvfix/csvfix/bin"
export MAILDIR="$HOME/Maildir"
#export POWERLINE="$HOME/powerline"
#export PYTHONPATH="$HOME:$HOME/toml.py:/home/teto/libnl/python/build/lib.linux-x86_64-3.3:$PYTHONPATH"
 

if [ -f "$HOME/root" ]; then
	. "$HOME/root/bin/thisroot.sh"
fi

# Var used by libvirt. Others also ?
# export SYSCONFDIR="$HOME/.config/libvirt" 
# libvirtd.conf
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
