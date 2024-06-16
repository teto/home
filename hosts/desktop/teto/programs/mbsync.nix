{
  config,
  lib,
  pkgs,
  ...
}:
{
  # disabled for now, use mbsync instead
  programs.mbsync = {
    enable = true;
    # package = mbsyncWrapper;
  };

}
