# if a process takeslonger than this, display its processing time
REPORTTIME=10
# delay to consider when changing vi mode
KEYTIMEOUT=0

powerline_path="/home/teto/powerline/powerline"

source ${powerline_path}/bindings/zsh/powerline.zsh

#RPROMPT='[%D{%L:%M:%S %p}]'

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
