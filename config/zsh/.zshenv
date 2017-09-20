# vim: set foldmethod=marker:
# See https://wiki.archlinux.org/index.php/XDG_Base_Directory_support#Partial to get aound
#  non XDG conformant programs

emulate sh -c "source ~/.bash_profile"

# check we are on nixos
#########################################
# true if file exists, aka if we are on nixos
test ! -f /etc/NIXOS
ON_NIXOS=$?


# TODO use them only when != nixos ?
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS=@im=fcitx

