{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.cliphist;
in
{
  options = {
    programs.cliphist = {
      enableFzfIntegration = lib.mkEnableOption "fzf integration";
      enablePrimary = (lib.mkEnableOption "fzf integration") // {
        description = "Watch wl-clipboard for primary selection";

      };
    };
  };
  config = lib.mkMerge [

    (lib.mkIf cfg.enableFzfIntegration {

      programs.bash.initExtra = ''
        cliphist list | fzf --no-sort | cliphist decode | wl-copy
      '';

    })

    (lib.mkIf cfg.enablePrimary {

    })

  ];
}
