{ config, lib, ... }:
{
  # see https://nixos.org/nixops/manual/#idm140737318329504
  # for nixops
  networking.firewall.checkReversePath = false;

  # see https://nixos.org/nix-dev/2015-July/017657.html for problems 
  # with /run/user/1000 size
  services.logind.extraConfig = ''
    RuntimeDirectorySize=5G
  '';

  virtualisation.libvirtd = {
    enable = true;
    # templates = /home/teto/testbed/templates;
    qemuVerbatimConfig = ''
      namespaces = []

      # Whether libvirt should dynamically change file ownership
      dynamic_ownership = 1

      # be careful for network teto might make if fail
      # same when creating the pool
      user="teto"
      group="libvirtd"
      '';
      # extraOptions
      # extraConfig
      # qemuPackage


    # TODO automate creation of networks
    # create it with `virsh -c qemu:///system`
    # $ net-define --file /home/teto/testbed/libvirtd-network.xml
    # net-start mptcpB
    # net-autostart mptcpB

# <network>
#   <name>mptcpB</name>
#   <uuid>6315c48b-b55e-459e-b1cf-a23426bf2790</uuid>
#   <forward mode='nat'/>
#   <bridge name='virbr1' stp='on' delay='0'/>
#   <mac address='52:54:00:ce:91:92'/>
#   <ip address='192.168.128.1' netmask='255.255.255.0'>
#     <dhcp>
#       <range start='192.168.128.2' end='192.168.128.254'/>
#     </dhcp>
#   </ip>
# </network>
  };
  systemd.services.libvirtd.restartIfChanged = lib.mkForce true;
}
