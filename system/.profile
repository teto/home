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
#export XDG_CONFIG_HOME="$HOME/.config"

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
