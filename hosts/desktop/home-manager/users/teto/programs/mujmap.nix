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
    # fqdn = null;
  };
}
