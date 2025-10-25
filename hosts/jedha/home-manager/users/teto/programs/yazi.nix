{
  config,
  pkgs,
  options,
  lib,
  flakeSelf,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # package = flakeSelf.inputs.yazi.packages.${pkgs.system}.yazi;
  };
}
