{ config, lib, pkgs, ... }:
let
   cfg = config.programs.upnp;
in {
  options = {
    programs.upnp = {
      enable = lib.mkEnableOption "upnp";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
  };
}
{
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ 1900 ];
}

