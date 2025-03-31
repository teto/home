{ lib
, flakeSelf
, pkgs 
, ... }:
# don't enable it since it will override my zle-keymap-select binding
# programs.starship =
{
  enable = lib.mkForce true;
  enableZshIntegration = true;
  enableBashIntegration = lib.mkForce true;
  package = pkgs.starship.overrideAttrs (oa: {
        patches =
          (oa.patches or [])
          ++ [
            # flakeSelf.inputs.starship-jj-patch
          ];
      });
  # settings = {};
}
