{
  # config,
  lib,
  pkgs,
  flakeSelf,
  withSecrets,
  ...
}:
let

  autoloadedModule =
    { pkgs, ... }@args:
    flakeSelf.inputs.haumea.lib.load {
      # name = "autoloaded";
      src = builtins.trace "${flakeSelf}/nixos/profiles/desktop" "${flakeSelf}/nixos/profiles/desktop";
      # TODO replace the traced path with lib.fileset.toSource once this loader
      # can receive a path rooted in the flake source.

      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        flakeSelf.inputs.haumea.lib.transformers.liftDefault
        (flakeSelf.inputs.haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };
in
{

  imports = [
    autoloadedModule

    flakeSelf.nixosModules.default-hm

    # flakeSelf.inputs.mptcp-flake.nixosModules.mptcp
    # flakeSelf.inputs.peerix.nixosModules.peerix

    # installed via HM
    flakeSelf.inputs.nix-index-database.nixosModules.nix-index
    flakeSelf.inputs.nix-cache-beacon.nixosModules.nix-cache-beacon
    flakeSelf.nixosModules.nvd
    flakeSelf.nixosModules.tetos

    flakeSelf.nixosProfiles.universal
    flakeSelf.nixosProfiles.avahi
    flakeSelf.nixosProfiles.nix-daemon
    flakeSelf.nixosModules.sudo
    flakeSelf.nixosModules.wireguard

    # ./ntp.nix

    ./pipewire.nix

    # TODO autoload it ?
    # ./desktop/sops.nix
  ];

  tetos.wireguard.enable = withSecrets;

  # attempt to print japanese characters
  services.kmscon = {
    enable = false; # disabled because it's ugly
    config = {
      font-name = "Noto Sans Mono CJK JP";
      hwaccel = true;
    };
  };

  fonts.enableDefaultPackages = true;

  console = {
    # seems like a kernel bug resets it https://github.com/NixOS/nixpkgs/issues/413128
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i28b.psf.gz";
    # font = "ter-v32n"; # Terminus font, larger size
    packages = [ pkgs.terminus_font ];
    useXkbConfig = true;
  };

  # TODO move to lemurs ?
  # exec ${lib.getExe config.programs.sway.package}
  environment.etc."lemurs/wayland/sway-systemd" = {
    mode = "755";
    # sway creates systemd.user.targets.sway-session
    # for now we import everything
    # /nix/store/rxzvps8zldnz4sgphbw6893n6ikai6gn-dbus-1.14.10/bin/dbus-update-activation-environment --systemd  --all
    # is this the one ?
    text = ''
      #! /bin/sh
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all;
      systemctl start --user --wait sway-session.service
    '';
  };

  # service-name
  #              is the friendly name the service is known by and looked up
  #              under.  It is case sensitive.  Often, the client program is
  #              named after the service-name.
  #
  #       port   is the port number (in decimal) to use for this service.
  #
  #       protocol
  #              is the type of protocol to be used.  This field should
  #              match an entry in the protocols(5) file.  Typical values
  #              include tcp and udp.
  #
  #       aliases
  #              is an optional space or tab separated list of other names
  #              for this service.  Again, the names are case sensitive.
  #
  # sources
  #      services.source = pkgs.iana-etc + "/etc/services";
  #
  ## /etc/protocols: IP protocol numbers.
  # protocols.source = pkgs.iana-etc + "/etc/protocols";
  # nusrp            49001/tcp  # Nuance Unity Service Request Protocol
  # nusdp-disc       49001/udp  # Nuance Unity Service Discovery Protocol
  # inspider         49150/tcp  # InSpider System
  environment.etc.services.text = lib.mkForce ''
    piper   10200/tcp
    hass    8123/tcp
  '';

  # { };

  # see https://github.com/NixOS/nixpkgs/issues/15293
  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # time.timeZone = "Asia/Tokyo";

  # Enabling this option is necessary for Qt plugins to work in the installed profiles (e.g.: ‘nix-env -i’ or ‘environment.systemPackages’).
  # enabled to solve issues with 'kcc' plugins seem to live in qtbase, yet for now I couldn't find a wayland one.
  qt.enable = true;

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  # let home-manager do it
  # xdg.portal = {
  #  # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in
  #  enable = true;
  #  xdgOpenUsePortal = true;

  #  # is this in configuration.nix ?
  #  config.common.default = "*";
  #              # {
  #              #   common = {
  #              #     default = [
  #              #       "gtk"
  #              #     ];
  #              #   };
  #              #   pantheon = {
  #              #     default = [
  #              #       "pantheon"
  #              #       "gtk"
  #              #     ];
  #              #     "org.freedesktop.impl.portal.Secret" = [
  #              #       "gnome-keyring"
  #              #     ];
  #              #   };
  #              #   x-cinnamon = {
  #              #     default = [
  #              #       "xapp"
  #              #       "gtk"
  #              #     ];
  #              #   };
  #              # }

  # };

  environment.systemPackages = [
    pkgs.noto-fonts-cjk-sans
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    # High quality BT calls
  };

  # console.font = "Lat2-Terminus16";
  # console.keyMap = "fr";

  # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
  # todo find a good japanese font
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      ubuntu-classic
      inconsolata # monospace
      noto-fonts-cjk-sans # asiatic
      nerd-fonts.fira-code # otherwise no characters
      nerd-fonts.droid-sans-mono # otherwise no characters

      font-awesome_5
      source-code-pro
      dejavu_fonts
      # Adobe Source Han Sans
      source-han-sans # sourceHanSansPackages.japanese
      fira-code-symbols # for ligatures
      iosevka
      # noto-fonts
    ];

    fontconfig = {
      enable = true;
      antialias = true; # some fonts can be disgusting else
      allowBitmaps = false; # ugly
      includeUserConf = true;
      cache32Bit = false; # defualt false

      defaultFonts = {

        monospace = [ "Noto Sans Mono CJK JP" ];
        sansSerif = [ "Fira code" ];

        # monospace = [ "" ];
        # sansSerif
        # Une police serif est une police avec de petits traits décoratifs au bout des lettres, appelés empattements
        serif = [ "" ];
        # sansSerif =
        emoji = [ ];
      };
      # confPackages = [];
    };
  };

  # can be configured through pam
  environment.etc."security/limits.conf".text = ''
    #[domain]        [type]  [item]  [value]
    teto  soft  core  unlimited
    teto  soft  memlock 128
    *  hard  memlock  256
    @audio   -  nice     -20
  '';

  boot.kernelParams = [
    # "boot.debug1devices"
  ];
  boot.kernel.sysctl."kernel.dmesg_restrict" = false;

  # boot.loader.timeout = lib.mkForce 5;
  system.nixos.distroName = "Tetonos";

  # systemd.services."systemd-coredump".serviceConfig.ProtectHome = false;
  # systemd.services."systemd-coredump@".serviceConfig.ProtectHome = false;
  # environment.etc."systemd/system/systemd-coredump@.service.d/override.conf".text = ''
  #   ProtectHome=no
  # '';
  # this is slow
  #   includeAllModules = true;
  # };

  # programs.file-roller.enable = true;
  programs.system-config-printer.enable = true;
}
