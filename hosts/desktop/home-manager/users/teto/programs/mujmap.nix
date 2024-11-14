{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Bridge for synchronizing email and tags between JMAP and notmuch 
  programs.mujmap = {
    enable = true;
    package = pkgs.mujmap-unstable;

    # fqdn = null;
  };
}
