{ pkgs, ... }:
{
  systemPackages = with pkgs; [
    bottles



    # cups-pk-helper # to add printer through gnome control center
    pkgs.lm_sensors # to see CPU temperature (command 'sensors')
    pkgs.vlc # to see it in popcorn

    # ubuntu-classic
    # inconsolata # monospace
    # noto-fonts-cjk-sans # asiatic
    # nerd-fonts.fira-code # otherwise no characters
    # nerd-fonts.droid-sans-mono # otherwise no characters
    #
    # font-awesome_5
    # source-code-pro
    # dejavu_fonts
    # # Adobe Source Han Sans
    # source-han-sans # sourceHanSansPackages.japanese
    # fira-code-symbols # for ligatures
    # iosevka
  ];

}
