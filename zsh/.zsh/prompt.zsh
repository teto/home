# if a process takeslonger than this, display its processing time
REPORTTIME=10

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


# explanations available here:
# http://www.acm.uiuc.edu/workshops/zsh/prompt/escapes.html
PROMPT='%K{blue}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white}  [%T]
%# %b%f%k'
#${PR_GREEN}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} ${PR_BOLD_BLUE}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} ${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(git_prompt_string)
#$(prompt_char) '

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

#RPROMPT='${PR_GREEN}$(virtualenv_info)%{$reset_color%} ${PR_RED}${ruby_version}%{$reset_color%}'

#PS1=%K{blue}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white} %# %b%f%k
