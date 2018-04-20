{ config, lib, pkgs,  ... }:
{

  services.tor = {
    enable = false;
    client.enable = true;
  };
}

