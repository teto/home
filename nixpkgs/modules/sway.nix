{ config, lib, pkgs,  ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  # programs.sway.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
  };
}
