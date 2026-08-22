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
      # secretsFolder = lib.mkOption {
      #   default = false;
      #   type = lib.types.str;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  # config = lib.mkIf cfg.enable {
  # };
}
