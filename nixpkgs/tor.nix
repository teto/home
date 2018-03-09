{ config, lib, pkgs,  ... }:
{

  services.tor = {
    enable = true;
    client.enable = true;
  };
}

