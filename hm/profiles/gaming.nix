# could be called home-huge.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    #   # lgogdownloader

    # gaming
    lutris
  ];

}
