{ pkgs, ... }:
{
  # with pkgs;
  systemPackages = [
    # cups-pk-helper # to add printer through gnome control center
    pkgs.lm_sensors # to see CPU temperature (command 'sensors')
    pkgs.vlc # to see it in popcorn
    pkgs.btop
  ];

  # /etc/mdns.allow, unused without mdns specfic enablement
  # etc."mdns.allow".text = ''
  #   *
  #   # .local.
  #   # .local
  # '';
}
