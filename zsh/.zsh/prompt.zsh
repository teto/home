# if a process takeslonger than this, display its processing time
REPORTTIME=10
# delay to consider when changing vi mode
KEYTIMEOUT=1
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# determine Ruby version whether using RVM or rbenv
# the chpwd_functions line cause this to update only when the directory changes
function _update_ruby_version() {
    typeset -g ruby_version=''
    if which rvm-prompt &> /dev/null; then
      # ruby_version="$(rvm-prompt i v g)"
      ruby_version="$(rvm-prompt i v p g)"
    else
      if which rbenv &> /dev/null; then
        ruby_version="$(rbenv version | sed -e "s/ (set.*$//")"
      fi
    fi
}

# list of functions to call for each directory change
chpwd_functions+=(_update_ruby_version)

function current_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

#include "ns3/string.h"#include "ns3/string.h"#include "ns3/string.h"<F9>
#include "ns3/string.h"
powerline_path=$(get_python_pkg_dir powerline)
powerline_path=""
if [[ $? -eq 0 && "$powerline_path" != "" ]]; then
	powerline-daemon -q
	source ${powerline_path}/bindings/zsh/powerline.zsh
else
	# Setup your normal PS1 here.
# explanations available here:
# http://www.acm.uiuc.edu/workshops/zsh/prompt/escapes.html
PROMPT='%K{blue}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white}  [%T]
%# %b%f%k'
#${PR_GREEN}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} ${PR_BOLD_BLUE}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} ${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(git_prompt_string)
#$(prompt_char) '
fi


RPROMPT='[%D{%L:%M:%S %p}]'


# this code makes the prompt blink which is bad
# TRAPALRM is called every TMOUT, in our case it will reset the prompt
#http://stackoverflow.com/questions/2187829/constantly-updated-clock-in-zsh-prompt
#TMOUT=1

#TRAPALRM() {
    #zle reset-prompt
#}


# prompt called in case of error
SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

#RPROMPT='${PR_GREEN}$(virtualenv_info)%{$reset_color%} ${PR_RED}${ruby_version}%{$reset_color%}'

#PS1=%K{blue}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white} %# %b%f%k
