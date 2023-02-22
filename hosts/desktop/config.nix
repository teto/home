{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix

    # todo renommer en workstation
    ../../modules/docker-daemon.nix

    ../config-all.nix
    ../desktop.nix
    ./sshd.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/experimental.nix
    ../../nixos/profiles/postgresql.nix
    ../../nixos/profiles/steam.nix
    ../../nixos/profiles/opensnitch.nix
    ../../nixos/profiles/gitlab-runner.nix
    ../../nixos/profiles/steam.nix

    ../../modules/libvirtd.nix
    ../../modules/xserver.nix
    ../../modules/redis.nix
    ../../modules/ntp.nix

    # just to check how /etc/nix/machines looks like
    ../../modules/distributedBuilds.nix

    # ./modules/syncthing.nix
    # ./modules/tor.nix
    # ./modules/sway.nix
    #   ./modules/mininet.nix

    # extra module not upstreamed yet
    # makes it crash
    # ({ config, lib, ... }:
    # {
    #   _file = "matt";
    #   # boot.kernel.checkPackageConfig = true;
    # })

  ];

  # for testing
  services.openssh = {

   # tu peux en avoir plusieurs sur ce mode
   # HostKey /etc/ssh/ssh_host_rsa_key
   # HostKey /etc/ssh/ssh_host_ed25519_key
   # alors que on a 
   # AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u
	hostKeys = [
	  {
		bits = 4096;
		path = "/etc/ssh/ssh_host_rsa_key";
		type = "rsa";
	  }
	  {
		path = "/etc/ssh/ssh_host_ed25519_key";
		type = "ed25519";
	  }
   ];

   # settings = {
	 # AuthorizedKeysCommand = "true";
	 # AuthorizedKeysCommandUser = "nobody";
   # };

   # > /nix/store/94paffh2ns62jjwfhf419hrcs2lalw8d-sshd.conf-validated line 5: no argument after keyword "ListenAddresses"
   # > /nix/store/94paffh2ns62jjwfhf419hrcs2lalw8d-sshd.conf-validated line 33: keyword Port extra arguments at end of line
   # settings.Port = [ 42 ];
   # 
   # AuthorizedKeysCommandUser
   #     Specifies the user under whose account the AuthorizedKeysCommand is run.  It is recommended to  use  a  dedi‐
   #     cated  user  that has no other role on the host than running authorized keys commands.  If AuthorizedKeysCom‐
   #     mand is specified but AuthorizedKeysCommandUser is not, then sshd(8) will refuse to start.
   # 	 Port 320
	 # Port 42
   extraConfig = ''
	AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%ujjk
	 AuthorizedKeysCommand none
	 # La question est: est-ce que AuthorizedKeysCommandUser est utilise si 
	 AuthorizedKeysCommandUser toto
	'';
  };

  users.users.teto.packages = with pkgs; [
    pciutils # for lspci
    ncdu # to see disk usage
    # bridge-utils# pour  brctl
    wirelesstools # to get iwconfig
    # aircrack-ng
  ];

  # nesting clones can be useful to prevent GC of some packages
  # https://nixos.org/nix-dev/2017-June/023967.html

  # system.requiredKernelConfig 


  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  # necessary for qemu  to prevent
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  boot.runSize = "10g";

  swapDevices = [{
    # label = "dartagnan";
    device = "/fucking_swap";
    size = 8192; # in MB
    # size = 4096; # in MB
    # size = 16000; # in MB
  }];

  boot.blacklistedKernelModules = [
    # "nouveau"
  ];

  boot.consoleLogLevel = 6;
  boot.loader = {
    #    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...
    systemd-boot.editor = true; # allow to edit command line
    timeout = 5;
    # just to generate the entry used by ubuntu's grub
    grub = {
      enable = true;
      useOSProber = true;
      # boot.loader.grub.version = 2;
      # install to none, we just need the generated config
      # for ubuntu grub to discover
      device = "/dev/sdb";


    };
  };

  # hide messages !
  boot.kernelParams = [
    # "earlycon=ttyS0"
    # "console=ttyS0" 
    # NECESSARY !! https://discourse.nixos.org/t/browsers-unbearably-slow-after-update/9414/30
    "intel_pstate=active"

	# see https://forums.developer.nvidia.com/t/unusable-linux-text-console-with-nvidia-drm-modeset-1-or-if-nvidia-persistenced-is-loaded/184428/14
	"no-scroll"
  ];

  # DOES NOT WORK !
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_0;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_mptcp_96;

  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "jedha"; # Define your hostname.

  networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.allowedTCPPorts = [ 8080 ];

  # temporary while working on result-store
  networking.firewall.allowedTCPPorts = [ 5000 52002 ];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = false;

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

  # programs.seahorse.enable = false; # UI to manage keyrings

  # List services that you want to enable:
  services = {
    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
    };

    # Enable CUPS to print documents.
    # https://nixos.wiki/wiki/Printing
    printing = {
      enable = true;
      browsing = false;
      drivers = [
        pkgs.gutenprint
        pkgs.gutenprintBin
        # See https://discourse.nixos.org/t/install-cups-driver-for-brother-printer/7169
        pkgs.brlaser
      ];
    };

    # just locate
    locate.enable = true;
    dbus.packages = [
      pkgs.deadd-notification-center # installed by systemd
      pkgs.gcr # for pinentry
      # pkgs.gnome.gdm
      # pkgs.gnome.gnome-control-center
    ];
  };


  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  # networking.enableIPv6 = false;


  # rtkit is optional but recommended {{{
  security.rtkit.enable = true;

  # }}}

  # kind of a test
  # security.pam.services.lightdm.enableGnomeKeyring = true;

  # will fial until openflowswitch is fixed
  programs.mininet.enable = false;

  # ebpf ?
  # broken in https://github.com/NixOS/nixpkgs/issues/56724
  # programs.bcc.enable = true;

  # services.xserver.displayManager.gdm.nvidiaWayland = true;

  # this is required as well
  hardware.nvidia = {
    # this makes screen go black on boot :/
    modesetting.enable = false; # needs "modesetting" in videoDrivers ?

    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false;
  };
  # environment.etc."gbm/nvidia-drm_gbm.so".source = "${nvidiaPackage}/lib/libnvidia-allocator.so";
  # environment.etc."egl/egl_external_platform.d".source = "/run/opengl-driver/share/egl/egl_external_platform.d/";

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # config from https://discourse.nixos.org/t/nvidia-users-testers-requested-sway-on-nvidia-steam-on-wayland/15264/32
  hardware.opengl.extraPackages = [
    # vaapiVdpau
    # libvdpau-va-gl
    # libva
  ];
  # security.sudo.wheelNeedsPassword = ;
  # disabled to run stable-diffusion
  services.xserver = {
    videoDrivers = [
      "nvidia"
	  "modesetting"
	  "fbdev"
    ];
    displayManager.gdm.wayland = true;
  };
  # system.replaceRuntimeDependencies
  #     List of packages to override without doing a full rebuild. The original derivation and replacement derivation must have the same name length, and ideally should have close-to-identical directory layout.

  environment.systemPackages = [
    # pkgs.linuxPackages.nvidia_x11.bin # to get nvidia-smi EVEN when nvidia is not used as a video driver
  ];

  # system.userActivationScripts

  # $out here is the profile generation
  system.extraSystemBuilderCmds = ''
    ln -s ${config.boot.kernelPackages.kernel.dev}/vmlinux $out/vmlinux
  '';
}
