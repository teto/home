
#zle-keymap-select () {
##	echo $TERM

    #if [ "$TERM" = "rxvt-unicode" ]; then
        #if [ $KEYMAP = vicmd ]; then
            #echo -ne "\033]12;Red\007"
        #else
            #echo -ne "\033]12;Grey\007"
        #fi
    #fi
#}
#zle -N zle-keymap-select

## set prompt to insertion mode
#zle-line-init () {
	#zle -K viins
#}
#zle -N zle-line-init

# Put the string "hostname::/full/directory/path" in the title bar:
function set_term_title {
  echo -ne "\e]2;$PWD\a"
}

# Put the parentdir/currentdir in the tab
function set_term_tab {
  echo -ne "\e]1;$PWD:h:t/$PWD:t\a"
}

function set_running_app {
  echo -ne "\e]1; $PWD:t:$(history $HISTCMD | cut -b7- ) \a"
}

function precmd {
  set_term_title
  set_term_tab
  #echo "hello world"
}

function preexec {
  set_running_app
}

function postexec {
  set_running_app
}

#function zle-keymap-select {
  #zle reset-prompt
#}

#zle -N zle-keymap-select

