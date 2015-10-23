#!/bin/sh
# change to zsh
chsh

gsettings set org.nemo.desktop show-desktop-icons false
gsettings set org.gnome.desktop.background show-desktop-icons false

# copy .desktop files to their directory
#desktop-file-install
# [/usr/local/share/applications
# be careful that local .desktop need relogin !
# desktop-file-validate
#~/.local/share/applications
sudo update-desktop-database

#xdg-settings set default-web-browser
# 
#run-parts --regex '*.cron' cron/
# TODO todo check varenv are set or set them here and write them into a file sourced by zsh ?
stow -t  "$XDG_DATA_HOME" local
stow -t  "$XDG_CONFIG_HOME" config
stow -t "$HOME/.ipython" ipython

ln -s "$HOME/dotfiles/texmf" "$HOME/texmf"
# TODO tex rehash

# regenerate the user font cache
# will look into folders listed in .fonts.conf
fc-cache -fv
