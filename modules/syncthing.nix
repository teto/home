{ config, lib, pkgs, ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  services.syncthing.enable = true;
}
