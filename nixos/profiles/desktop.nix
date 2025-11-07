{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
let

  autoloadedModule =
    { pkgs, ... }@args:
    flakeSelf.inputs.haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        root = ./desktop;
      };

      inputs = args // {
        inputs = flakeSelf.inputs;
        # inherit config;
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
    flakeSelf.nixosModules.nvd
    flakeSelf.nixosModules.universal
    flakeSelf.nixosProfiles.gnome
    flakeSelf.nixosModules.nix-daemon
    flakeSelf.nixosModules.sudo

    ./greetd.nix
    ./ntp.nix
    ../modules/network-manager.nix
    # ../../nixos/profiles/librenms.nix

    ./pipewire.nix

    # TODO autoload it ?
    # ./desktop/sops.nix
  ];

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

  # to get manpages
  documentation.enable = true;
  # set it to true to help
  documentation.nixos.includeAllModules = false;

  # on master it is disabled
  documentation.man.enable = true; # temp
  documentation.doc.enable = false; # builds html doc, slow
  documentation.info.enable = false;

  environment.systemPackages = [ ];

  # networking.firewall.checkReversePath = false; # for nixops
  # networking.firewall.allowedUDPPorts = [ 631 ];
  # networking.firewall.allowedTCPPorts = [ 631 ];

  hardware = {
    # enableAllFirmware =true;
    enableRedistributableFirmware = true;
    # High quality BT calls
  };

  # console.font = "Lat2-Terminus16";
  # console.keyMap = "fr";

  # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
  # todo find a good japanese font
  fonts = {
    fontDir.enable = true; # ?
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

        sansSerif = [ "Noto Sans CJK JP" ];

        # monospace = [ "" ];
        # serif = [ "" ];
        # sansSerif =
      };
    };
  };

  # systemd.packages = [ ];

  nix = {

    # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
    # daemonIONiceLevel = 3;
    # prepending with 'flake:' makes HM copy a lot more thna just 'path:'
    nixPath = [
      "nixpkgs=/home/teto/nixpkgs"
    ];

    settings.log-lines = 20;
    # either use --option extra-binary-caches http://hydra.nixos.org/
    # handy to hack/fix around
    # readOnlyStore = false;
  };

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

  # then coredumpctl debug will launch gdb !
  # boot.kernel.sysctl."kernel.core_pattern" = "core"; to disable.
  # security.pam.loginLimits
  systemd.coredump.enable = false;

  # see
  #JournalSizeMax=767M
  #MaxUse=
  #KeepFree=
  systemd.coredump.extraConfig = ''
    #Storage=external
    #Compress=yes
    ProcessSizeMax=5G
    ExternalSizeMax=10G
  '';

  # systemd.services."systemd-coredump".serviceConfig.ProtectHome = false;
  # systemd.services."systemd-coredump@".serviceConfig.ProtectHome = false;
  # environment.etc."systemd/system/systemd-coredump@.service.d/override.conf".text = ''
  #   ProtectHome=no
  # '';
  # this is slow
  documentation.nixos.enable = true;

  # programs.file-roller.enable = true;
  programs.system-config-printer.enable = true;

}
