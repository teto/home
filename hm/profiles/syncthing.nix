{ config, pkgs, lib, ... } @ args:
{
  services.syncthing = {
    enable = true;
  };
}

