{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{
  _imports = [
    flakeSelf.homeProfiles.sway
  ];

  # windowManager.sway = ;
}
