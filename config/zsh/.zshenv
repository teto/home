# vim: set foldmethod=marker:
# See https://wiki.archlinux.org/index.php/XDG_Base_Directory_support#Partial to get aound
#  non XDG conformant programs


export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# PATH {{{
#PATH="/usr/lib/w3m:$PATH"
# PATH="$PATH:/home/teto/mptcpanalyzer"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH" # haskell
# PATH="$HOME/dotfiles/bin:$PATH"
PATH+=":$HOME/rofi-scripts"
PATH+=":$XDG_DATA_HOME/fzf/bin"
PATH+=":/home/teto/texlive/bin/x86_64-linux"
PATH+=":/home/teto/dasht/bin"


# set PATH so it includes user's private bin if it  exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
#echo $PATH
export PATH
# }}}
# simulate XDG for some apps {{{
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export INPUTRC="$XDG_CONFIG_HOME/readline"
export TIGRC_USER="$XDG_CONFIG_HOME/tig/tigrc"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/jupyter
#}}}
# PYTHONPATH {{{
# no need to export, install in develop mode
# PYTHONPATH="$PYTHONPATH:$HOME/i3ipc-python"
# export PYTHONPATH

# lldb python plugin is badly installed/setup
# location=$(lldb -P)
# location="/usr/lib/x86_64-linux-gnu/python2.7/site-packages:/usr/lib/python2.7/dist-packages/lldb-3.8"
# if [ $? -eq 0 ]; then
# 	PYTHONPATH="${location}:$PYTHONPATH"
# fi
# }}}

export VAGRANT_DEFAULT_PROVIDER="libvirt"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export GOPATH="$HOME/go"

# to prevent a matplotlib pb
export MPLBACKEND="Qt5Agg"
#export ZDOTDIR="$HOME/.zsh"

# TODO try removing ?
export MUTT="$XDG_CONFIG_HOME/mutt"
export MAILDIR="$HOME/Maildir"

# export DASHT_DOCSETS_DIR
# rust install folder
export CARGO_HOME="$XDG_DATA_HOME/../"

# default programs {{{
export EDITOR="nvim"
export TERMINAL="termite"
export BROWSER="x-www-browser"
# export BROWSER="qutebrowser --backend webengine"
# }}}

# careful ! it's not a classic terminfo root with /X/Xname
# it will just look for files in this directory
export TERMINFO="${XDG_CONFIG_HOME:-~/.config}/terminfo"
# see :h $NVIM_LOG_FILE
# export NVIM_LOG_FILE="~/.nvimlog"
# can remove NORC once pb in nvim fixed
export MANPAGER="nvim -u NORC -c 'set ft=man' -"
# export MANPAGER="less"
export MANPATH="$HOME/dasht/man:$MANPATH"

# FZF {{{
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_OPTS=" --exact"
export FZF_DEFAULT_OPTS=" --exact"
#--color=
# }}}
# for DCE/ns3 experiments {{{
# remove automatic access to kernel since we may want to look at it
# in $HOME/libos-tools
# created this kind of problem :/
# <3>net/mptcp/mptcp_ctrl.c: mptcp_add_sock: token 0x635c914e pi 2, src_addr:0.0.0.0:0 dst_addr:0.0.0.0:0, cnt_subflows now 2
DCE_PATH="$HOME/libos-tools" # for libsim-linux.so (modified version of libos-tools can create a liblinux.so)
# so reverted back to plain old net-next-sim
# DCE_PATH="$HOME/mptcpoff" # for liblinux.so
DCE_PATH="$DCE_PATH:$HOME/iproute2/ip" # for 'ip' program
DCE_PATH="$DCE_PATH:$HOME/iperf3/src"
DCE_PATH="$DCE_PATH:$HOME/iperf2/src"
# now for ntp experiments
DCE_PATH="$DCE_PATH:$HOME/ntimed" 
DCE_PATH="$DCE_PATH:$HOME/openntpd"
DCE_PATH="$DCE_PATH:$HOME/chrony"
DCE_PATH="$DCE_PATH:$HOME/ntpoff/ntpd"



export DCE_PATH

# for ns3 testing
export DCE_FOLDER="$HOME/dce2"
export NS3_FOLDER="$HOME/ns3off2"
export NS3_TESTING="$HOME/ns3testing"
# }}}
