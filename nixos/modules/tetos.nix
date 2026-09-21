{
  config,
  lib,
  pkgs,
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
    };
  };

  # config = lib.mkIf cfg.enableYubikey {
  #   # dictated by https://nixos.wiki/wiki/Yubikey
  #
  # };
}
