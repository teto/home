/*

The website can't actually be run automatically (yet) since nixpkgs lacks some lua modules (lapis)

*/
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.luarocks-site;
  # wireshark = cfg.package;
in {
  options = {
    services.luarocks-site = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to run an equivalent of www.luarocks.org website
          '';
      };
    };
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ wireshark ];
    # users.groups.wireshark = {};
    # TODO enable postgresql / redis /  nginx


  };
}

