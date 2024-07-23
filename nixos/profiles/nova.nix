{
  config,
  lib,
  pkgs,
  ...
}:
{

  # for sharedssh access
  # services.gvfs.enable = true;

  imports = [ ];
  services.tailscale = {

    enable = true;

    # necessary for headscale
    useRoutingFeatures = "client";
  };

  environment.systemPackages = [
    pkgs.dbeaver-bin
    pkgs.tailscale-systray
  ];

  # to test locally
  # services.gitlab-runner.enable = true;

  # nix = {
  # };
  #
  # programs.fuse.userAllowOther = false;
}
