# vim: set noet fenc=utf-8 ff=unix  sts=0 sw=4 ts=8 foldmethod=marker :
# useless since it is generated by powerline


# add 'j' command
. /usr/share/autojump/autojump.sh

# for VTE-based terminals. In termite Ctrl + Shift + t opens terminal in cwd
source /etc/profile.d/vte.sh


source "$ZDOTDIR/aliases.zsh"
# notifies when long command finishes
source "$ZDOTDIR/zbell.zsh" 

#source $ZDOTDIR/hooks.zsh

# adds a transfer function to upload a file & display its url
source "$ZDOTDIR/transfer.zsh"


# Mail check {{{
#MAILDIR="$HOME/Maildir"
#MAILCHECK=1000 # interval in seconds


# Transform maildir boxes (/lists/ )
#for i in $MAILDIR/**/new(/N); do
	  #mailpath+=("${i}?You have new mail in ${i:h:t}.")
#done
# }}}

# History parameters {{{
HISTSIZE=10000
SAVEHIST=9000
HISTFILE="$XDG_CACHE_HOME/zsh_history.tmp"

# make some commands not show up in history
export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:date:* --help"

# multiple zsh sessions will append to the same history file (incrementally, after each command is executed)
# setopt inc_append_history

setopt hist_expire_dups_first # purge duplicates first


setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
# setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history
# }}}

# Zsh options {{{1
setopt beep # (no_)beep don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack

# ===== Expansion and Globbing
#setopt noextended_glob # treat #, ~, and ^ as part of patterns for filename generation


# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

setopt dotglob # add hidden files to glob results

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
#setopt correct # spelling correction for commands
#setopt correctall # spelling correction for arguments

# Prompt {{{2
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
#setopt checkwinsize # redraw window if changes size
# setopt transient_rprompt # only show the rprompt on the current prompt
# }}}

# Scripts and Functions
#setopt multios # perform implicit tees or cats when multiple redirections are attempted
# SMART URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

#}}}

# Bindings ZLE commands {{{1
# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey "^K"      kill-whole-line                      # ctrl-k
bindkey "^R"      history-incremental-search-backward  # ctrl-r
bindkey "^A"      beginning-of-line                    # ctrl-a  
bindkey "^E"      end-of-line                          # ctrl-e
bindkey "[B"      history-search-forward               # down arrow
bindkey "[A"      history-search-backward              # up arrow
bindkey "^D"      delete-char                          # ctrl-d
bindkey "^F"      forward-char                         # ctrl-f
bindkey "^B"      backward-char                        # ctrl-b

bindkey -v   # Default to standard vi bindings, regardless of editor string

zle -N edit-command-line

# Press ESC-v to edit current line in your favorite $editor
bindkey -M vicmd v edit-command-line
bindkey '^R' history-incremental-search-backward

#bindkey "q" push-line
#bindkey 'q' push-line-or-edit
bindkey '^A' push-line-or-edit

bindkey '^P' up-history
bindkey '^N' down-history
# }}}

# Fancy CTRL Z {{{
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
# }}}

# Why did I put that ?
export SYSCONFDIR="$XDG_CONFIG_HOME"


# Setup zsh-autosuggestions
#source /home/teto/zsh-autosuggestions/autosuggestions.zsh

## Enable autosuggestions automatically
#zle-line-init() {
    #zle autosuggest-start
#}

#zle -N zle-line-init

eval "`dircolors -b "$XDG_CONFIG_HOME/dircolors/solarized.ansi-dark"`"



# Look if zsh autosuggestions improve things
#autoload predict-on
#predict-on
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -U compinit && compinit
autoload -z edit-command-line

zmodload -i zsh/complist


# man zshcontrib
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:*' enable git #svn cvs 

add-zsh-hook preexec set_term_title
#add-zsh-hook zsh_directory_name
add-zsh-hook precmd update_term_title

# completion config {{{1
# enables autocompletion for apt
compdef apt=apt-get

# zsh searches $fpath for completion files
fpath=( $ZDOTDIR/completions $fpath )

# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-~/.cache}/zsh/cache/$HOST"

# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''

# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# insert all expansions for expand completer
# zstyle ':completion:*:expand:*' tag-order all-expansions
 
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
 
# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

#zstyle ':completion:*' rehash true
# tab completion for PIDs {{{2
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm,command -w -w"
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
# }}}

# }}}


# works in termite
function set_term_title (){
    print -Pn "\e]0;$(echo "$1")\a"
}

function rprompt_cmd() {
    # get vcs info
    vcs_info

    echo "${vcs_info_msg_0_}"
}


update_term_title () {
    set_term_title $(pwd)
}

# Pour afficher la commande dans le titre du terminal
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
source "$ZDOTDIR/prompt.zsh"

# prompt config {{{1
#PROMPT='$(prompt_cmd)' # single quotes to prevent immediate execution
# 
#PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"
#RPROMPT='' # no initial prompt, set dynamically


## trying to get async update of git in case repo is big
## http://www.anishathalye.com/2015/02/07/an-asynchronous-shell-prompt/
#ASYNC_PROC=0
#function precmd() {
    #function async() {
        ## save to temp file
        #printf "%s" "$(rprompt_cmd)" > "${HOME}/.zsh_tmp_prompt"

        ## signal parent
        #kill -s USR1 $$
    #}

    ## do not clear RPROMPT, let it persist

    ## kill child if necessary
    #if [[ "${ASYNC_PROC}" != 0 ]]; then
        #kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    #fi

    ## start background computation
    #async &!
    #ASYNC_PROC=$!

    ## update title
    #printf '\e]0;%s@%s: %s\a' "toto" "${prompt_host}" "${prompt_char}"
#}

#function TRAPUSR1() {
    ## read from temp file
    #RPROMPT="$(cat ${HOME}/.zsh_tmp_prompt)"

    ## reset proc number
    #ASYNC_PROC=0

    ## redisplay
    #zle && zle reset-prompt
#}
## }}}

## use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
## zsh-autosuggestions is designed to be unobtrusive)
#bindkey '^T' autosuggest-toggle
#install it first
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable FZF fuzzy matcher {{{
FZF_PATH="$XDG_DATA_HOME/fzf/shell/"
source "$FZF_PATH"/completion.zsh
source "$FZF_PATH"/key-bindings.zsh
# }}}

# _gnu_generic should work if program accepts --help
compdef _gnu_generic qutebrowser
compdef _gnu_generic mptcpanalyzer

# added by Nix installer
if [ -e /home/teto/.nix-profile/etc/profile.d/nix.sh ]; then . /home/teto/.nix-profile/etc/profile.d/nix.sh; fi 




[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
