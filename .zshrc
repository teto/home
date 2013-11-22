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

# Schémas de complétion
                                                                                                        
# - Schéma A :
# 1ère tabulation : complète jusqu'au bout de la partie commune
# 2ème tabulation : propose une liste de choix
# 3ème tabulation : complète avec le 1er item de la liste
# 4ème tabulation : complète avec le 2ème item de la liste, etc...
# -> c'est le schéma de complétion par défaut de zsh.

# Schéma B :
# 1ère tabulation : propose une liste de choix et complète avec le 1er item
#                   de la liste
# 2ème tabulation : complète avec le 2ème item de la liste, etc...
# Si vous voulez ce schéma, décommentez la ligne suivante :
#setopt menu_complete

# Schéma C :
# 1ère tabulation : complète jusqu'au bout de la partie commune et
#                   propose une liste de choix
# 2ème tabulation : complète avec le 1er item de la liste
# 3ème tabulation : complète avec le 2ème item de la liste, etc...
# Ce schéma est le meilleur à mon goût !
# Si vous voulez ce schéma, décommentez la ligne suivante :
unsetopt list_ambiguous
# (Merci à Youri van Rietschoten de m'avoir donné l'info !)
# Quand le dernier caractère d'une complétion est '/' et que l'on
# tape 'espace' après, le '/' est effacé
setopt auto_remove_slash
# Ne fait pas de complétion sur les fichiers et répertoires cachés
unsetopt glob_dots

# Traite les liens symboliques comme il faut
setopt chase_links

# Quand l'utilisateur commence sa commande par '!' pour faire de la
# complétion historique, il n'exécute pas la commande immédiatement
# mais il écrit la commande dans le prompt
setopt hist_verify
# Si la commande est invalide mais correspond au nom d'un sous-répertoire
# exécuter 'cd sous-répertoire'
setopt auto_cd
# L'exécution de "cd" met le répertoire d'où l'on vient sur la pile
setopt auto_pushd
# Ignore les doublons dans la pile
setopt pushd_ignore_dups
# N'affiche pas la pile après un "pushd" ou "popd"
setopt pushd_silent
# "pushd" sans argument = "pushd $HOME"

# Ne stocke pas  une ligne dans l'historique si elle  est identique à la
# précédente
setopt hist_ignore_dups
                                                                                                        
# Supprime les  répétitions dans le fichier  d'historique, ne conservant
# que la dernière occurrence ajoutée
#setopt hist_ignore_all_dups

# Supprime les  répétitions dans l'historique lorsqu'il  est plein, mais
# pas avant
setopt hist_expire_dups_first

# N'enregistre  pas plus d'une fois  une même ligne, quelles  que soient
# les options fixées pour la session courante
#setopt hist_save_no_dups

# La recherche dans  l'historique avec l'éditeur de commandes  de zsh ne
# montre  pas  une même  ligne  plus  d'une fois,  même  si  elle a  été
# enregistrée
setopt hist_find_no_dups

# Lowers the delay time between the prefix key and other keys - fixes pausing in vim
 set -sg escape-time 1


# reload .tmux.conf
#bind-key r source-file ~/.tmux.conf \; display-message "TMUX Configuration reloaded"
#bind-key r source-file ~/.zshrc \; display-message "ZSH Configuration reloaded"

# show vim status
# # http://zshwiki.org/home/examples/zlewidgets
# if I could change the cursor instead that would be great
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/NORMAL}/(main|viins)/INSERT}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select


# Affiche le code de sortie si différent de '0'                                                         
setopt print_exit_value



alias sz='source ~/.zshrc'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

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

# PROMPT="%{$fg_bold[cyan]%}$ZSH_THEME_CLOUD_PREFIX %{$fg_bold[green]%}%p %{$fg[green]%}%c %{$fg_bold[cyan]%}$(vcs_info_msg_0_)%{$fg_bold[blue]%} % %{$reset_color%}"
