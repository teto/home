{
  config,
  lib,
  pkgs,
  ...
}:

{

  # experimental
  # services.voxinput.enable = true;

  # not merged yet
  virtualisation.libvirtd.qemu.user = "teto";
}
