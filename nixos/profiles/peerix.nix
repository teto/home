{ config, pkgs, lib, ... } @ args:
{
  services.peerix = {
    enable = true;
    openFirewall = true;
  };
}
