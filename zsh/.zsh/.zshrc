#source ~/.zsh/checks.zsh
#source $ZDOTDIR/path.zsh
source $ZDOTDIR/autojump.zsh
source $ZDOTDIR/colors.zsh
source $ZDOTDIR/setopt.zsh
source $ZDOTDIR/exports.zsh
source $ZDOTDIR/git_prompt.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/bindkeys.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/history.zsh
source $ZDOTDIR/hooks.zsh
source $ZDOTDIR/mail.zsh
source $ZDOTDIR/transfer.zsh
#source  ${HOME}/.dotfiles/z/z.sh

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
