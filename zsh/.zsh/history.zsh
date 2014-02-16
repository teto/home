# HISTORY
HISTSIZE=10000
SAVEHIST=9000
HISTFILE=~/.zsh_history



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






