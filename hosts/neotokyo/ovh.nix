{ config, lib, pkgs, ... }:
{
    

  # boot.loader.grub.enable = true;
  # # boot.loader.grub.useOSProber = false;
  # boot.loader.grub.device = lib.mkForce "/dev/sda";

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot/ESP0"; }
      { devices = [ "nodev" ]; path = "/boot/ESP1"; }
    ];
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Don't put NixOS kernels, initrds etc. on the ESP, because
  # the ESP is not RAID1ed.
  # Mount the ESP at /boot/efi instead of the default /boot so that
  # boot is just on the / partition.
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";


  # boot.loader.systemd-boot.enable = true;
  # # boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  # boot.loader.efi.canTouchEfiVariables = true;
 
}
