{
  lib,
  flakeSelf,
  pkgs,
  ...
}:
# don't enable it since it will override my zle-keymap-select binding
{
  enable = lib.mkForce true;
  enableZshIntegration = true;
  enableBashIntegration = lib.mkForce true;
  enableFishIntegration = false;
  package = pkgs.starship.overrideAttrs (oa: {
    patches = (oa.patches or [ ]) ++ [
      # flakeSelf.inputs.starship-jj-patch
    ];
  });
  # settings = {};
}
