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

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

