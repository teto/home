{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  unstable = import <nixos-unstable> {}; # https://nixos.org/channels/nixos-unstable
in
{
  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    /etc/nixos/hardware-configuration.nix

    ./modules/distributedBuilds.nix
    ./config-all.nix
    ./common-desktop.nix
    ./modules/network-manager.nix
    ./modules/libvirtd.nix
    ./modules/vpn.nix

    # see clone for that
    # ./modules/proxy.nix

    # ihaskell marked as broken :'(
    # ./modules/jupyter.nix
  #   ./modules/mininet.nix

    # extra module not upstreamed yet
    ({ config, lib, ... }:
    {
      boot.enforceRequiredConfig = true;

    })
    # ./modules/mptcp.nix

    # for user teto
    ./extraTools.nix
  ]
  ;

  # nesting clones can be useful to prevent GC of some packages
  # https://nixos.org/nix-dev/2017-June/023967.html

  fileSystems."/mnt/ext" =
    { device = "/dev/sda4";
    options = [ "user" "exec" ];
    };

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  # TODO look at
  # boot.specialFileSystems.

  # NEW
  # hardware.printers = 

  # necessary for qemu  to prevent
# client> qemu-img: Error while writing to COW image: No space left on device
#   * client: command ‘['qemu-img', 'rebase', '-f', 'qcow2', '-b', '', '/run/user/1000/nixops-tmpV3FOyf/disk-client.qcow2']’ failed on machine ‘client’ (exit code 1)
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  boot.runSize = "10g";

  swapDevices = [{
    # label = "dartagnan";
    device = "/fucking_swap";
    size = 8192; # in MB
    # size = 16000; # in MB
  } ];

  boot.blacklistedKernelModules = [
    # "nouveau"
  ];

  boot.consoleLogLevel=6;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...
    systemd-boot.editor = true; # allow to edit command line
    timeout = 5;
  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
    grub.device = "/dev/sda";
  };

  # hide messages !
  # boot.kernelParams = [ "earlycon=ttyS0" "console=ttyS0" ];
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.my_lenovo_kernel;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;


  # TODO we need nouveau  ?
  # lib.mkMerge
  boot.kernelModules =  [
    "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "jedha"; # Define your hostname.

  # TODO add the chromecast
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = false;
  networking.interfaces = {
      # macAddress = "3B-0B-B5-6A-ED-91";
      eno1 = {
        name = "proxy"; useDHCP=true;  mtu=1500;
        # I just want to use 
        ipv4.routes = [
          { address = "10.0.0.0"; prefixLength = 16; }
          # { address = "192.168.2.0"; prefixLength = 24; via = "192.168.1.1"; }
        ];
      };
      # eth1 = { name = "eth1"; useDHCP=true; };
  };


  # to allow wireshark to capture from netlink
  networking.localCommands = ''
    ip link show nlmon0
    if [ $? -ne 0 ]; then
      ip link add nlmon0 type nlmon
      ip link set dev nlmon0 up
    fi
  '';


  # List services that you want to enable:
  services = {
    gnome3 = {
      gnome-keyring.enable = true;
      seahorse.enable = true; # UI to manage keyrings
      at-spi2-core.enable = true; # for keyring it seems
	  gnome-disks.enable = false;
    };

    # Enable CUPS to print documents.
    # https://nixos.wiki/wiki/Printing
    printing = {
      enable = true;
      browsing = false;
      drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    };


    # just locate
    locate.enable = true;

    # dbus.packages = [ ];
  };

      # overlays =
      # let path = ../overlays; in with builtins;
      # map (n: import (path + ("/" + n)))
      #     (filter (n: match ".*\\.nix" n != null ||
      #                 pathExists (path + ("/" + n + "/default.nix")))
      #             (attrNames (readDir path)))
      # ++ [ (import ./envs.nix) ];

  nixpkgs.overlays = [
    (import <nixpkgs-overlays/kernels.nix>)
    # (import ./overlays/haskell.nix) 
  ];

  nixpkgs.config.allowUnfree = true;

  # <nixos-overlay>
  # just for testing
  # services.qemuGuest.enable = true;

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=30
  '';

  # to prevent
  # The VirtualBox Linux kernel driver (vboxdrv) is either not loaded or there is a permission problem with /dev/vboxdrv. Please reinstall the kernel module by executing '/sbin/vboxconfig' as root.

  # virtualisation.virtualbox = {
  #   host.enable = true;
  #   host.enableExtensionPack = true;
  #   host.addNetworkInterface = true; # adds vboxnet0
  #   # Enable hardened VirtualBox, which ensures that only the binaries in the system path get access to the devices exposed by the kernel modules instead of all users in the vboxusers group.
  #    host.enableHardening = true;
  #    host.headless = false;
  # };

  # test with mininet VM
  # fileSystems."/virtualbox" = {
     # fsType = "vboxsf";
  #   device = "tschlenk";
  #   options = "rw,uid=1000,gid=100";
  # };

  # services.telnet = {
  #   enable = true;
  #   openFirewall = true;
  #   # port = ;
  # };
  services.xserver = {
    displayManager.lightdm = {
      autoLogin = {
        enable = true;
        user = "teto";

      };
      # background = ;
    };
    displayManager.slim = {
        autoLogin = true;
        defaultUser = "teto";
    };

    # set the correct primary monitor
    xrandrHeads = [
      {
        primary = true;
        # monitorConfig = ''
        #   '';

        output = "DP-2";
      }
    ];

    videoDrivers = [ "nvidia" ];
  };


# hardware.nvidia.package

  # docker pull mattator/dce-dockerfiles
  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  #   # logDriver = 
  #   # liveRestore
  # };

  # services.xserver.displayManager.gdm = {
  # };

  nix = {
    sshServe = {
      enable = false;
      protocol = "ssh";
      # keys = [ secrets.gitolitePublicKey ];
    };

    distributedBuilds = false;
    package = pkgs.nixFlakes;
  };

  # kind of a test
  security.pam.services.lightdm.enableGnomeKeyring = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # will fial until openflowswitch is fixed
  programs.mininet.enable = false;
  # test with sudo mn --switch ovsk -v debug

  # networking.iproute2.enable = true;

  # networking.mptcp = {
  #   enable = true;
  #   debug = true;
  #   pathManager = "netlink";
  #   package = pkgs.linux_mptcp_trunk_raw;
  # };

  # once available
  services.greenclip.enable = true;

  # services.owamp.enable = true;

  # ebpf ?
  # broken in https://github.com/NixOS/nixpkgs/issues/56724
  programs.bcc.enable = true;

  environment.systemPackages = with pkgs;
    (import ./basetools.nix { inherit pkgs;})
    # strongswan # to get ipsec in path
    # cups-pk-helper # to add printer through gnome control center
    ++ [
    # firefox
      ]
  ;

  # pour l'instant je les ai mis dans conf.d direct pour les tests
  # networking.networkmanager = {
  #   extraConfig = ''
  #     '';
  # };

  # programs.ccache = {
  #   enable = false;
  #   # cacheDir = 
  #   # packageNames = [ "wxGTK30" "qt48" "ffmpeg_3_3" "libav_all" ];
  #   packageNames = ["linux_mptcp_trunk_raw"];

  # };

  # services.squid.enable = true;
  # proxyPort

  # see https://github.com/NixOS/nixpkgs/pull/45345
  # switch to it via
  # sudo /run/current-system/fine-tune/child-1/bin/switch-to-configuration test
  nesting.clone = [
      {

        imports = [
          ./modules/proxy.nix
        ];
        boot.loader.grub.configurationName = "with proxy";
        # networking.proxy.default = "http://proxy.work.com:80";
        # networking.proxy.noProxy = "127.0.0.1,localhost,work.com";
        # nix.binaryCaches = [
        #         "http://nixcache.work.com"
        #         "https://cache.nixos.org"
        # ];
      }
  ];

       # system.replaceRuntimeDependencies
       #     List of packages to override without doing a full rebuild. The original derivation and replacement derivation must have the same name length, and ideally should have close-to-identical directory layout.

# system.userActivationScripts
  # system.copySystemConfiguration = true;
  # see https://www.mail-archive.com/nix-commits-bounces@lists.science.uu.nl/msg04507.html

  # marked as internal
  # $out here is the profile generation
  system.extraSystemBuilderCmds = ''
    ln -s ${config.boot.kernelPackages.kernel.dev}/vmlinux $out/vmlinux
  '';

}
