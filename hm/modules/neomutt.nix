{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.foo;
in
{
  options = {
    programs.foo = {
      enableProfiling = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };
}
