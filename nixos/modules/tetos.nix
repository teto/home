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
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  config = lib.mkIf cfg.enable {
  };
}
