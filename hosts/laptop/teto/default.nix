# home-manager specific config from
{ config, lib, pkgs
, flakeInputs
, ... }:
{

  imports = [
   ./sway.nix
   ./programs/waybar.nix
   ./services/mpd.nix
   ./services/blueman-applet.nix
   ./services/swayidle.nix

    # ../../../hm/profiles/emacs.nix
    ../../../hm/profiles/nova.nix
    # ../../../hm/profiles/qutebrowser.nix

   # ../desktop/teto/default.nix  # Track for regressions

   ../../desktop/teto/programs/neovim.nix
   ../../desktop/teto/services/swaync.nix
   ../../desktop/teto/contacts.nix
   ../../desktop/teto/mail.nix
   ../../desktop/teto/programs/helix.nix
   ../../desktop/teto/programs/yazi.nix

    ../../../hm/profiles/desktop.nix
    ../../../hm/profiles/sway.nix
    ../../../hm/profiles/swayidle.nix
    ../../../hm/profiles/extra.nix
    ../../../hm/profiles/japanese.nix

    ../../../hm/profiles/dev.nix
    ../../../hm/profiles/experimental.nix
    # ../../hm/profiles/syncthing.nix
    # ../../hm/profiles/alot.nix
    # ../../hm/profiles/vscode.nix #  provided by nova-nix config
  ];

  package-sets = {
   enableDesktopGUIPackages= true;
   wifiPackages = true;
  };

  # dans le cadre de mon experimentation !
  home.packages = with pkgs; [
    flakeInputs.rippkgs.packages.${pkgs.system}.rippkgs
    flakeInputs.rippkgs.packages.${pkgs.system}.rippkgs-index

    timg # to display images in terminal, to compare with imgcat ?
    imagemagick # for 'convert'
    ubuntu_font_family
    inconsolata # monospace
    noto-fonts-cjk # asiatic
    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # nerdfonts
    # corefonts # microsoft fonts  UNFREE
    font-awesome_5
    source-code-pro
    dejavu_fonts
    # Adobe Source Han Sans
    source-han-sans #sourceHanSansPackages.japanese
    fira-code-symbols # for ligatures
    iosevka

    tree 
    # noto-fonts
  ];

  programs.neovim.enable = true; 
}
