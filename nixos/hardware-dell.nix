# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1078767c-bd06-47c3-8e4b-2d7c7760e8f7";
      fsType = "ext4";
    };

  fileSystems."/hdd" =
    {
      device = "/dev/sda1";
      fsType = "ntfs";
      options = [ "rw" "data=ordered" "relatime" ];
    };
  # swapDevices = [ ];

  # nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "powersave";
}
