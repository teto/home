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
