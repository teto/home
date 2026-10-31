{
  config,
  lib,
  ...
}:
let
  cfg = config.tetos;
in
{
  options = {
    tetos = {
      withSecrets = lib.mkEnableOption "withSecrets";
      # enableYubikey = lib.mkEnableOption "yubikey";
      # one for wireguard
      # secretsFolder = lib.mkOption {
      #   default = false;
      #   type = lib.types.str;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };

      allowUpnp = lib.mkEnableOption "allowUpnp";
    };
  };

  config = lib.mkIf cfg.allowUpnp {
    # SSDP discovery probes should target  o
    networking.firewall.allowedUDPPorts = [ 1900 ];
  };
}
