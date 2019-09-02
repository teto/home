#  vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
#  zsh specific aliases only
#
# https://stackoverflow.com/questions/24601806/got-permission-denied-when-emulating-sh-under-zsh
emulate sh -c "source $ZDOTDIR/aliases.sh"
#
# Suffix aliases execute a command based on a file’s extension. Suffix aliases are used with the alias -s command.  Here’s my favorite feature of aliases in zsh.  By adding this line:
# g => global , does not depend on position on line
# todo find a better option relying on xdg-open etc...
alias -s html=qutebrowser
alias -s json=nvim
alias -s Vagrantfile=nvim
alias -s png=sxiv
alias -s jpg=xdg-open
alias -s gif=xdg-open
alias -s avi=mpv
alias -s mp3=mocp
alias -s pdf=xdg-open
alias -s doc=xdg-open
alias -s docx=xdg-open


alias dfh="df --human-readable"
alias duh="du --human-readable"


alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# alias se="sudoedit"
# alias ec='$EDITOR $XDG_CONFIG_HOME/'


# Gestion du 'ls' : couleur & ne touche pas aux accents
# alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'

# if [ -x /usr/bin/dircolors ]; then
# #    eval "`dircolors -b`"
#     alias dir='dir --color=auto'
#     alias vdir='vdir --color=auto'

#     alias grep='grep --color=auto'
#     alias fgrep='fgrep --color=auto'
#     alias egrep='egrep --color=auto'
# fi

