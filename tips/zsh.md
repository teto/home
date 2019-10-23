#

"zle -N" Create a user-defined widget.  If there is already a widget with the specified name, it is overwritten

zle -al lists all registered widgets

echo $widgets[accept-line]

you can run zsh -f. If you want to skip system configuration files but run the per-user files, run zsh -d.

zsh/zleparameter

