{ config, lib, touchegg, ... }:
{
  # for nixops
  virtualisation.libvirtd = {
    enable = true;
    qemuVerbatimConfig = ''
      namespaces = []

      # Whether libvirt should dynamically change file ownership
      dynamic_ownership = 1
      # be careful for network teto might make if fail
      user="teto"
      group="libvirtd"
      '';
  };
  systemd.services.libvirtd.restartIfChanged = lib.mkForce true;
}
