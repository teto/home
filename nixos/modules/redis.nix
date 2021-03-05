{ config, lib, pkgs, ... }:
{
  services.redis = {
    enable = true;
    logLevel = "debug";

    openFirewall = false;

    # settings = {};
  };
}
