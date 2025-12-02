{
  config,
  lib,
  pkgs,
  ...
}:
{

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "";
  };

  boot.loader.efi.canTouchEfiVariables = false;

  # Don't put NixOS kernels, initrds etc. on the ESP, because
  # the ESP is not RAID1ed.
  # Mount the ESP at /boot/efi instead of the default /boot so that
  # boot is just on the / partition.
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";

}
