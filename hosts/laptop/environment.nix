{ pkgs, ... }:
{
  systemPackages = with pkgs; [
    # cups-pk-helper # to add printer through gnome control center
    pkgs.lm_sensors # to see CPU temperature (command 'sensors')
    pkgs.vlc # to see it in popcorn

    pkgs.nerdfonts
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
    source-han-sans # sourceHanSansPackages.japanese
    fira-code-symbols # for ligatures
    iosevka
  ];

}
