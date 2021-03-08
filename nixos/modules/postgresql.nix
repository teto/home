{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
  };
}
