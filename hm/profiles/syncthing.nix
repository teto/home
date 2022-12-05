{ config, pkgs, lib, ... } @ args:
let
  # secrets = import ./secrets.nix;
in
{
  services.syncthing = {
    enable = true;
  };
}

