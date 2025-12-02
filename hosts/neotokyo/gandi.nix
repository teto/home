{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/openstack-config.nix"
  ];

  boot.initrd.kernelModules = [
    "xen-blkfront"
    "xen-tpmfront"
    "xen-kbdfront"
    "xen-fbfront"
    "xen-netfront"
    "xen-pcifront"
    "xen-scsifront"
  ];

  # This is to get a prompt via the "openstack console url show" command
  systemd.services."getty@tty1" = {
    enable = lib.mkForce true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Restart = "always";
  };

  boot.loader.grub.device = lib.mkForce "/dev/xvda";

}
