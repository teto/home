{ config, pkgs, options, lib, ... }:
{
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableExtensionPack = true;
    host.addNetworkInterface = true; # adds vboxnet0
    # Enable hardened VirtualBox, which ensures that only the binaries in the system path get access to the devices exposed by the kernel modules instead of all users in the vboxusers group.
     host.enableHardening = false;
     host.headless = false;
  };
}
