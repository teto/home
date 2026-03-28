{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{
  # Bridge for synchronizing email and tags between JMAP and notmuch
  enable = true;
  package = flakeSelf.inputs.mujmap.packages.${pkgs.stdenv.hostPlatform.system}.mujmap;

  # fqdn = null;
}
