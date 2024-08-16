{
  config,
  pkgs,
  options,
  lib,
  flakeInputs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # package = flakeInputs.yazi.packages.${pkgs.system}.yazi;
  };
}
