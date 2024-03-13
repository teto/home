# home-manager specific config from
{ config, lib, pkgs, ... }:
{

  imports = [
   ./sway.nix
   ./programs/waybar.nix
   ./teto/services/mpd.nix

    ../../hm/profiles/emacs.nix
    ../../hm/profiles/nova.nix
    ../../hm/profiles/qutebrowser.nix


   # ../desktop/teto/default.nix  # Track for regressions
   ../desktop/teto/programs/neovim.nix
   ../desktop/teto/services/swaync.nix
   ../desktop/teto/contacts.nix
   ../desktop/teto/programs/helix.nix

    ../../hm/profiles/vdirsyncer.nix
    ../../hm/profiles/desktop.nix
    ../../hm/profiles/sway.nix
    ../../hm/profiles/waybar.nix
    # ../../hm/profiles/weechat.nix
    ../../hm/profiles/extra.nix
    # ../../hm/profiles/syncthing.nix
    ../../hm/profiles/japanese.nix

    # ../../hm/profiles/alot.nix
    ../../hm/profiles/dev.nix
    # ../../hm/profiles/vscode.nix #  provided by nova-nix config
    ../../hm/profiles/experimental.nix
    # ../../hm/profiles/emacs.nix
  ];

  # dans le cadre de mon experimentation !
  home.packages = with pkgs; [
    timg # to display images in terminal, to compare with imgcat ?
    # lua
    imagemagick # for 'convert'
    chromium
    ubuntu_font_family
    inconsolata # monospace
    noto-fonts-cjk # asiatic
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # nerdfonts
    # corefonts # microsoft fonts  UNFREE
    font-awesome_5
    source-code-pro
    dejavu_fonts
    # Adobe Source Han Sans
    source-han-sans #sourceHanSansPackages.japanese
    fira-code-symbols # for ligatures
    iosevka
    # noto-fonts
  ];

  programs.neovim.enable = true; 

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

}
