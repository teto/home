{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{
  imports = [
    # flakeSelf.homeProfiles.teto-desktop
  ];

  home.packages = [

    flakeSelf.inputs.lux.packages.${pkgs.stdenv.hostPlatform.system}.lux-cli
  ];
}
