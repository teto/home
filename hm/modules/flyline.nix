# 
{ config, lib, pkgs, osConfig ? null, ... }:
let
   cfg = config.programs.flyline;
in {
  options = {
    programs.flyline = {

      enable = lib.mkEnableOption "flyline";

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

    # the bash builtin is loaded by the flyline nixos module, this module only configures it
    assertions = [
      {
        assertion = osConfig != null && (osConfig.programs.flyline.enable or false);
        message = "programs.flyline: the home-manager module requires the flyline NixOS module (flakeSelf.inputs.flyline.nixosModules.default) with programs.flyline.enable = true.";
      }
    ];

    programs.bash.initExtra = ''
      flyline set-cursor --backend terminal
      # simple/disabled/smart
      # flyline mouse --mode smart
      flyline editor --show-inline-history false
      flyline editor --select-with-mouse false
      flyline history --backend flyline
      source ${../../config/bash/flyline.sh}

      '';
  };
}
