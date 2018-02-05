{ pkgs, ... }:
with pkgs; [
          buku
          dropbox
          haskellPackages.greenclip # todo get from haskell
          libreoffice
          mendeley
          gnome3.nautilus
          gnome3.gnome_control_center
          transmission_gtk
          qtpass
          qutebrowser
          xorg.xev
          xclip
          zathura
          zotero
          qtcreator
          zeal
]
