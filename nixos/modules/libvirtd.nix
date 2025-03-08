# Extends  the default module to be able to run as my current user
{ lib, config, ... }:
let
  cfg = config.virtualisation.libvirtd;
in
{

  user = lib.mkOption {
    type = lib.types.str;
    default = "root";
    description = ''
      TODO
    '';
    # If false, libvirtd runs qemu as unprivileged user qemu-libvirtd.
    # Changing this option to false may cause file permission issues
    # for existing guests. To fix these, manually change ownership
    # of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
  };

  # users.extraUsers.myuser.extraGroups = [ "libvirtd" ];
  system.activationScripts.libvirtd-chown = ''
    chown ${cfg.qemu.user}:root /var/lib/libvirt/qemu
    chown ${cfg.qemu.user}:root /var/lib/libvirt/images
  '';

}
