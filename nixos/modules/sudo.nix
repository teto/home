{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.sudo;
in
{
  options = {
    security.sudo = {
      bellOnPrompt = lib.mkEnableOption {
        description = "Enable bell on sudo";
        # default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # TODO check for bellOnPrompt
      {
        security.sudo.extraConfig = ''
          Defaults        passprompt="[sudo] password for %p: ", timestamp_timeout=360, timestamp_type=global
        '';
      }
    ]
  );

}
