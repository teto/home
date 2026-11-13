{ config, lib, ... }:
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
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ 1900 ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [8200];
# # SSDP multicast discovery port (UDP)
# sudo ufw allow 1900/udp comment 'DLNA SSDP'
#
# # MiniDLNA HTTP streaming & web status port (TCP)
# sudo ufw allow 8200/tcp comment 'MiniDLNA HTTP'

  };
}

