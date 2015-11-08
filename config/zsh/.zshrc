# vim: set noet fenc=utf-8 ff=unix  sts=0 sw=4 ts=8 foldmethod=marker
##source ~/.zsh/checks.zsh
#source $ZDOTDIR/path.zsh
#source $ZDOTDIR/autojump.zsh
#source $ZDOTDIR/colors.zsh
# useless since it is generated by powerline
#source $ZDOTDIR/git_prompt.zsh

. /usr/share/autojump/autojump.sh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/hooks.zsh
source $ZDOTDIR/transfer.zsh
#source  ${HOME}/.dotfiles/z/z.sh


# Mail check {{{
MAILDIR="$HOME/Maildir"
MAILCHECK=100 # interval in seconds


# Transform maildir boxes (/lists/ )
for i in $MAILDIR/**/new(/N); do
	  mailpath+=("${i}?You have new mail in ${i:h:t}.")
done
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
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history
# }}}

# Zsh options {{{
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

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
#setopt correct # spelling correction for commands
#setopt correctall # spelling correction for arguments

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
#setopt checkwinsize # redraw window if changes size
# setopt transient_rprompt # only show the rprompt on the current prompt

# ===== Scripts and Functions
#setopt multios # perform implicit tees or cats when multiple redirections are attempted
# SMART URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# }}}

# Bindings {{{
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
#
# Setup zsh-autosuggestions
#source /home/teto/zsh-autosuggestions/autosuggestions.zsh

## Enable autosuggestions automatically
#zle-line-init() {
    #zle autosuggest-start
#}

#zle -N zle-line-init

## use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
## zsh-autosuggestions is designed to be unobtrusive)
#bindkey '^T' autosuggest-toggle

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
