{ config
, lib
, pkgs
, modulesPath
, ...
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
  


  boot.loader.grub.device = lib.mkForce "/dev/xvda";


}
