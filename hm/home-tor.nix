{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nyx # what's that ?
    # firefoxPackages.tor-browser
  ];
}
