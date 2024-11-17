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
    config = lib.mkEnableOption {
      description = "Enable bell on sudo";
      # default = false;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        config.security.sudo.extraConfig = ''
          Defaults        passprompt="[sudo] password for %p: ", timestamp_timeout=360, timestamp_type=global
        '';
      }
    ]
  );

}
