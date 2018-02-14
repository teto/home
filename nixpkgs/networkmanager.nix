{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.gnome3.networkmanagerapplet
  ];

  networking.networkmanager = {
    enable = true;
    # logLevel = WARN;
    # dispatcherScripts
    # packages = [];
  };

}
