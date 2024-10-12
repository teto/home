{ flakeInputs, pkgs, ... }:
{
  enable = true;
  package = flakeInputs.yazi.packages.${pkgs.system}.yazi;

  # plugins = {
  # }
}
