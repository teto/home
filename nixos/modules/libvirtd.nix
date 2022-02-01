{ config, lib, pkgs, ... }:
{
  # dont filter DHCP packets
  # https://github.com/nix-community/nixops-libvirtd#prepare-libvirtd
  networking.firewall.checkReversePath = false;

  # see https://nixos.org/nix-dev/2015-July/017657.html for problems 
  # with /run/user/1000 size
  services.logind.extraConfig = ''
    RuntimeDirectorySize=3G
  '';

  environment.systemPackages = [
    # to run ubuntu, needs libvirtd service
    pkgs.virt-manager  # broken)
  ];

  virtualisation.libvirtd = {
    enable = true;
    # templates = /home/teto/testbed/templates;
    # See 1:qemu.qemu_agent 1:qemu.qemu_monitor
    # See https://wiki.libvirt.org/page/DebugLogs
      # extraOptions
      # extraConfig
      # qemuPackage
    extraConfig=''
      # log_level = 1
      # # no filter for now
      # log_filters="1:qemu.qemu_agent 1:qemu.qemu_monitor"
      # # log_filters="3:remote 4:event 3:json 3:rpc"
      # log_outputs="1:file:/var/log/libvirt/libvirtd.log"
    '';
      # qemuVerbatim
      # namespaces = []
      # # Whether libvirt should dynamically change file ownership
      # # dynamic_ownership = 1
      # # be careful for network teto might make if fail
      # # same when creating the pool
      # user="teto"
      # group="libvirtd"

    # qemuRunAsRoot=false;
# virtualisation.libvirtd.qemu.runAsRoot
    qemu.user = "teto";

    qemu.verbatimConfig = ''
      # https://github.com/libvirt/libvirt/blob/master/src/qemu/qemu.conf
      namespaces = []
      # Whether libvirt should dynamically change file ownership
      # dynamic_ownership = 1
      # be careful for network teto might make if fail
      # same when creating the pool
      user="teto"
      group="libvirtd"

      # Whether libvirt should dynamically change file ownership
      # to match the configured user/group above. Defaults to 1.
      # Set to 0 to disable file ownership changes.
      dynamic_ownership = 0
    '';

    extraOptions= [
      # very verbose but in a non-interesting way
      # "--verbose"
    ];




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
#   <ip address='192.168.148.1' netmask='255.255.255.0'>
#     <dhcp>
#       <range start='192.168.148.2' end='192.168.148.254'/>
#     </dhcp>
#   </ip>
# </network>
  };
  systemd.services.libvirtd.restartIfChanged = lib.mkForce true;

  # TODO write my own to change permissions
  systemd.services.libvirtd-teto = {
    description = "Libvirt Virtual Machine Management Daemon - configuration";
    script = ''
      images=/home/teto/images
      sudo mkdir "$images"
      sudo chgrp libvirtd "$images"
      sudo chmod g+w "$images"
    '';

  #   serviceConfig = {
  #     Type = "oneshot";
  #     RuntimeDirectoryPreserve = "yes";
  #     LogsDirectory = subDirs [ "qemu" ];
  #     RuntimeDirectory = subDirs [ "nix-emulators" "nix-helpers" "nix-ovmf" ];
  #     StateDirectory = subDirs [ "dnsmasq" ];
  #   };
  };
}
