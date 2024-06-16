{
  config,
  lib,
  pkgs,
  ...
}:
{

  # for android development
  services.avahi.enable = true;

  # check https://github.com/NixOS/nixpkgs/issues/49630
  # networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  # environment.systemPackages = with pkgs; [
  #   (chromium.override {
  #     commandLineArgs = "--load-media-router-component-extension=1";
  #   })
  # ];
}
