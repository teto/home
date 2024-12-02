{
  config,
  flakeInputs,
  flakeSelf,
  modulesPath,
  withSecrets,
  lib,
  pkgs,
  ...
}:
let
  autoloadedModule =
    { pkgs, ... }@args:
    flakeInputs.haumea.lib.load {
      src = flakeInputs.nix-filter {
        root = ./.;
        exclude = [
          "teto"
          "users"
          "home-manager"
          "root"
        ];
      };

      inputs = args // {
        inputs = flakeInputs;
      };
      transformer = [
        flakeInputs.haumea.lib.transformers.liftDefault
        (flakeInputs.haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{
  imports =
    [
      autoloadedModule # loaded by haumea
      ./_boot.nix
      ../../nixos/profiles/greetd.nix

      # todo renommer en workstation

      ../../nixos/profiles/docker-daemon.nix
      flakeSelf.nixosModules.novaModule
      flakeSelf.nixosModules.desktop
      flakeSelf.nixosModules.nix-daemon
      flakeSelf.nixosModules.steam
      flakeSelf.nixosModules.universal
      # ../../nixos/profiles/experimental.nix
      # ../../nixos/profiles/opensnitch.nix
      # ../../nixos/profiles/podman.nix

      # ../../nixos/profiles/libvirtd.nix
    ]
    ++ lib.optionals withSecrets [
      # TODO restore
      # ./teto/restic.nix

      # TODO moved from their
      # ../../nixos/profiles/localai.nix
      ../../nixos/profiles/nextcloud.nix
      ../../nixos/profiles/postgresql.nix
      ../../nixos/profiles/redis.nix

    ]

  ;

  # TODO check how it interacts with less
  # environment.etc."inputrc".source = ../../config/inputrc;

  # just for fun ?
  # services.desktopManager.plasma6.enable = true;

  home-manager.users =
    # let
    # hmRootModule = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
    #  src = ./root;
    #  inputs = args // {
    #    inputs = flakeInputs;
    #  };
    #  transformer =  [
    #    flakeInputs.haumea.lib.transformers.liftDefault

    #  #  (x: hoistAttrs x )
    #    # (x: )
    #  ];
    #   # flakeInputs.haumea.lib.transformers.liftDefault;
    # };
    # in 
    {
      root = {
        imports = [
          # hmRootModule
          ./root/programs/ssh.nix
          ../../hm/profiles/nova/ssh-config.nix
        ];
      };

      # TODO use from flake or from unstable
      # services.opensnitch-ui.enable
      # ./hm/profiles/gaming.nix
      teto = {
        # TODO it should load the whole folder
        imports = [
          ./home-manager/users/teto/default.nix
          flakeSelf.homeModules.teto-nogui
        ];
      };
    };

  # boot.kernel.sysctl."kernel.dmesg_restrict" = false;

  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6; # works

  # services.xserver.displayManager.gdm.enable = true;

  # nesting clones can be useful to prevent GC of some packages
  # https://nixos.org/nix-dev/2017-June/023967.html

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  boot.blacklistedKernelModules = [ "nouveau" ];

  # necessary for qemu  to prevent
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  boot.runSize = "10g";

  swapDevices = [
    {
      # label = "dartagnan";
      device = "/fucking_swap";
      # size = 8192; # in MB
      # size = 4096; # in MB
      size = 16000; # in MB
    }
  ];

  boot.consoleLogLevel = 6;

  boot.loader = {
    systemd-boot.enable = false;
    # systemd-boot.editor = true; # allow to edit command line
    # systemd-boot.consoldeMode = "auto"; 

    efi.canTouchEfiVariables = true;
    # defaults to /boot
    efi.efiSysMountPoint = "/boot";
    #    systemd-boot.enable = true;
    # efi.efiSysMountPoint
    #    timeout = 5;
    #    # just to generate the entry used by ubuntu's grub
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = false;
      useOSProber = true;

      # install to none, we just need the generated config
      # for ubuntu grub to discover
      # device = "/dev/nvme0n1p3";
      devices = [ "nodev" ];
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
    # fsck.mode=skip
  ];

  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];

  boot.kernel.sysctl = {

    # max_user_instances limits (roughly) how many applications can watch files (per user);
    # max_user_watches limits how many filesystem items can be watched, in total across all applications (per user);
    # max_queued_events limits how many filesystem events will be held in the kernel queue if the application does not read them;

    # to avoid "Bad file descriptor" and "Too many open files" situations
    "fs.inotify.max_user_watches" = 1000000;
    "fs.inotify.max_user_instances" = 600;
    # "fs.inotify.max_queued_events" = ;

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
  networking.firewall.allowedTCPPorts = [
    # 5000 52002
  ];

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

  i18n.glibcLocales = pkgs.glibcLocales.override {
    # hum
    allLocales = true;
    # 229 fr_FR.UTF-8/UTF-8 \
    # 230 fr_FR/ISO-8859-1 \
    # 231 fr_FR@euro/ISO-8859-15 \
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ja_JP.utf8"
    ];
  };

  # List services that you want to enable:
  services = {
    # gnome = {
    #   gnome-keyring.enable = true;
    #   at-spi2-core.enable = true; # for keyring it seems
    # };

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
      # pkgs.deadd-notification-center # installed by systemd
      pkgs.gcr # for pinentry
      # pkgs.gnome.gdm
      # pkgs.gnome.gnome-control-center
    ];
  };

  services.xserver = {
    videoDrivers = [
      # "nouveau"
      "nvidia"
    ];
  };

  # networking.enableIPv6 = false;
  # rtkit is optional but recommended {{{
  security.rtkit.enable = true;

  # }}}

  # ebpf ?
  # broken in https://github.com/NixOS/nixpkgs/issues/56724
  # programs.bcc.enable = true;

  # /alsa-base.conf
  environment.etc."modprobe.d/alsa.conf".text = ''
    # we want nvidia to get index 1 see 
    # https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture#Set_the_default_sound_card
    options snd_hda_intel index=1
  '';

  # set on shell initialisation (e.g. in /etc/profile
  environment.variables = {
    # TODO move
    WLR_NO_HARDWARE_CURSORS = "1";

    # see if it is correctly interpolated
    # TODO remove ?
    ZDOTDIR = "$HOME/.config/zsh";
  };

  # variables set by PAM early in the process
  #   Also, these variables are merged into environment.variables[
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # system.replaceRuntimeDependencies
  #     List of packages to override without doing a full rebuild. The original derivation and replacement derivation must have the same name length, and ideally should have close-to-identical directory layout.

  # environment.systemPackages = [
  #   # pkgs.ntfsprogs
  #
  #   # (builtins.trace "${myNvim}" myNvim)
  # ];

  # $out here is the profile generation
  system.extraSystemBuilderCmds = ''
    ln -s ${config.boot.kernelPackages.kernel.dev}/vmlinux $out/vmlinux
  '';

  # use systemd program to set permissions instead of a nixpkgs script
  # might break some permissions see https://github.com/NixOS/nixpkgs/pull/353659
  # systemd.sysusers.enable = true;

  # just to test
  # https://www.freedesktop.org/software/systemd/man/latest/systemd-sysupdate.html
  systemd.sysupdate.enable = false;


  # SHould be a level instead ?
  # systemd.enableStrictShellChecks = true;

  users = {
    groups.nginx.gid = config.ids.gids.nginx;

    users = {
      nginx = {
        group = "nginx";
        # cfg.group;
        isSystemUser = true;
        uid = config.ids.uids.nginx;
      };
    };
  };

  system.stateVersion = "24.05";
}
