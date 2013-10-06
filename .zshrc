# Path to your oh-my-zsh configuration.


# Customize to your needs...
# export PATH=$PATH:/home/teto/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
# =======
# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1


# Allow shared history
#setopt histignorealldups sharehistory
# Allow for functions in the prompt.
setopt PROMPT_SUBST

# prevents the same command from being registered twice
setopt histignoredups

# allow to change directory without entering "d"
setopt AUTO_CD
# This makes cd=pushd
setopt AUTO_PUSHD


# Don't overwrite, append!
setopt APPEND_HISTORY
# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS
# Save the time and how long a command ran
setopt EXTENDED_HISTORY
# Use emacs keybindings even if our EDITOR is set to vi
# -v to use vi keybindings
bindkey -v


alias sz='source ~/.zshrc'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# custom scripts
source ~/.shellhelpers/*

# Use modern completion system
autoload -Uz compinit
compinit


# to get intel about Versioning Control Systems 
autoload -Uz vcs_info

#vcs_info_printsys


# URxvt keys
watch=all


# configure vcs
# enable => Disable everything but specified
zstyle ':vcs_info:*' enable git svn
#zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true
zstyle ':vcs_info:git*' formats "%c%u %b%m" # hash changes branch misc
zstyle ':vcs_info:*'    formats "%f[%%n@%%m %1~] $ " "%f%a %F{3}%m%u%c %f%b:%r/%S" 
zstyle ':vcs_info:*'    nvcsformats   "%f[%n@%m %1~]$ " ""
zstyle ':vcs_info:*'    actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '



zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# cwd change callback
function update_urxvt_title()
{
# 2 to change title only
	echo -e "\e]2;$PWD\a"
}

precmd() {
	    vcs_info
}

source "$HOME/.zshalias"

#source /usr/local/lib/python3.3/dist-packages/Powerline-beta-py3.3.egg/powerline/bindings/zsh/powerline.zsh

# source my local script
FOLDER="$HOME/.shellhelpers"

. $FOLDER

# list of callbacks that are called on cwd change
chpwd_functions=(${chpwd_functions[@]} "update_urxvt_title")

RPS1='${vcs_info_msg_0_} %T'



##### ALIASES #####
alias svim="sudo vim"

# PROMPT="%{$fg_bold[cyan]%}$ZSH_THEME_CLOUD_PREFIX %{$fg_bold[green]%}%p %{$fg[green]%}%c %{$fg_bold[cyan]%}$(vcs_info_msg_0_)%{$fg_bold[blue]%} % %{$reset_color%}"
