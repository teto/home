{
  config,
  flakeSelf,
  # modulesPath,
  withSecrets,
  lib,
  pkgs,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  # NOT READY YET
  autoloadedHmModule =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        root = ./home-manager/users/teto;
        exclude = [
          # "teto"
          # "users"
          "home-manager" # exclude home-manager because intputs are not the same: it must be imported differently
          # "root"
        ];
      };

      inputs = args // {
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

  autoloadedNixosModule =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        root = ./.;
        exclude = [
          # "teto"
          # "users"
          "default.nix"
          "home-manager" # exclude home-manager because intputs are not the same: it must be imported differently
          # "root"
        ];
      };

      inputs = args // {
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{
  imports = [
    autoloadedNixosModule # loaded by haumea
    ./_boot.nix

    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-master
    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-worker
    # use nixpkgs
    flakeSelf.inputs.harmonia.nixosModules.harmonia
    flakeSelf.nixosProfiles.greetd
    flakeSelf.nixosProfiles.desktop
    flakeSelf.nixosProfiles.nix-daemon

    flakeSelf.nixosProfiles.steam
    flakeSelf.nixosProfiles.universal

    # flakeSelf.nixosProfiles.pixiecore
    # flakeSelf.nixosProfiles.podman
    # flakeSelf.nixosProfiles.opensnitch
  ]
  ++ lib.optionals withSecrets [
    # TODO restore
    # ./teto/restic.nix

    # TODO moved from their
    # ../../nixos/profiles/localai.nix
  ];

  home-manager.users = {
    # TODO use from flake or from unstable
    teto = {
      # TODO it should load the whole folder
      imports = [
        ./home-manager/users/teto/default.nix
        # autoloadedHmModule # TODO fix
      ];
    };
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_17;

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  boot.blacklistedKernelModules = [ "nouveau" ];

  # necessary for qemu  to prevent
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  boot.runSize = "10g";

  swapDevices = [
    {
      device = "/fucking_swap";
      size = 48000; # in MB
    }
  ];

  boot.consoleLogLevel = 6;

  boot.loader = {
    systemd-boot.enable = false;
    # systemd-boot.editor = true; # allow to edit command line
    # systemd-boot.consoldeMode = "auto";

    # efi.canTouchEfiVariables = true;
    # defaults to /boot
    efi.efiSysMountPoint = "/boot";
    #    systemd-boot.enable = true;
    # efi.efiSysMountPoint
    #    timeout = 5;
    #    # just to generate the entry used by ubuntu's grub
    grub = {
      enable = true;
      efiSupport = true;
      # If you turn this feature on, GRUB will install itself in a special location within efiSysMountPoint (namely EFI/boot/boot$arch.efi) which the firmwares are hardcoded to try first, regardless of NVRAM EFI variables.
      efiInstallAsRemovable = true;
      #
      useOSProber = true;

      # install to none, we just need the generated config
      # for ubuntu grub to discover
      # boot.loader.grub.device has to be set to nodev 465, otherwise the grub installer will assume it has to install the Legacy (MBR) bits too. When doing so, it will either embed itself into
      # device = "/dev/nvme0n1p3";
      devices = [ "nodev" ];
    };
  };

  # hide messages !
  boot.kernelParams = [
    # "earlycon=ttyS0"
    # "console=ttyS0"
    # NECESSARY !! https://discourse.nixos.org/t/browsers-unbearably-slow-after-update/9414/30
    # "intel_pstate=active"

    # see https://forums.developer.nvidia.com/t/unusable-linux-text-console-with-nvidia-drm-modeset-1-or-if-nvidia-persistenced-is-loaded/184428/14
    "no-scroll"
    # fsck.mode=skip
  ];

  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
    "kvm"
    # https://discourse.nixos.org/t/ddcci-kernel-driver/22186/3
    "i2c-dev"
    "ddcci_backlight" # to control external monitors brightness
  ];

  boot.kernel.sysctl = {

    # max_user_instances limits (roughly) how many applications can watch files (per user);
    # max_user_watches limits how many filesystem items can be watched, in total across all applications (per user);
    # max_queued_events limits how many filesystem events will be held in the kernel queue if the application does not read them;

    # to avoid "Bad file descriptor" and "Too many open files" situations
    "fs.inotify.max_user_watches" = lib.mkForce 1000000;
    "fs.inotify.max_user_instances" = 600;
    # "fs.inotify.max_queued_events" = ;

    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  # system.replaceRuntimeDependencies
  #     List of packages to override without doing a full rebuild. The original derivation and replacement derivation must have the same name length, and ideally should have close-to-identical directory layout.

  powerManagement = {
    enable = true;
    powertop = {
      enable = true;
      postStart = ''
        echo 'on' > '/sys/bus/usb/devices/1-5.4/power/control';
        echo 'on' > '/sys/bus/usb/devices/1-9/power/control';
        echo 'enabled' > '/sys/class/net/wlp10s0/device/power/wakeup';
      '';
    };
  };

  # $out here is the profile generation
  # system.systemBuilderCommands = ''
  #   ln -s ${config.boot.kernelPackages.kernel.dev}/vmlinux $out/vmlinux
  # '';

  # SHould be a level instead ?
  # systemd.enableStrictShellChecks = true;

  # users = {
  #   groups.nginx.gid = config.ids.gids.nginx;
  #
  # };

  system.stateVersion = "25.05";
}
