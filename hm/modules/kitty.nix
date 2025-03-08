{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.kitty;
in
{
  options = {
    programs.kitty = {
      enableScrollback = lib.mkEnableOption "kitty";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enableScrollback {
    programs.kitty.settings = {
      scrollback_pager = ''nvim -R -c ":set ft=terminal" -c "set concealcursor=n" '';
    };
  };
}
