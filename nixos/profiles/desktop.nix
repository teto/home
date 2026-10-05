{
  # config,
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

      inputs =  args // {
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
    flakeSelf.inputs.flyline.nixosModules.default

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

  # see https://github.com/NixOS/nixpkgs/issues/15293
  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # time.timeZone = "Asia/Tokyo";

  # Enabling this option is necessary for Qt plugins to work in the installed profiles (e.g.: ‘nix-env -i’ or ‘environment.systemPackages’).
  # enabled to solve issues with 'kcc' plugins seem to live in qtbase, yet for now I couldn't find a wayland one.
  qt.enable = true;

  # let home-manager do it
  xdg.portal = {
    #  # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in
    #  enable = true;
    #  xdgOpenUsePortal = true;

    #  # is this in configuration.nix ?
    config.common.default = "*";
  };
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
    # packages = with pkgs; [
    #   ubuntu-classic
    #   inconsolata # monospace
    #   noto-fonts-cjk-sans # asiatic
    #   nerd-fonts.fira-code # otherwise no characters
    #   nerd-fonts.droid-sans-mono # otherwise no characters
    #
    #   font-awesome_5
    #   source-code-pro
    #   dejavu_fonts
    #   # Adobe Source Han Sans
    #   source-han-sans # sourceHanSansPackages.japanese
    #   fira-code-symbols # for ligatures
    #   # noto-fonts
    # ];

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

  boot.kernelParams = [
    # "boot.debug1devices"
  ];
  boot.kernel.sysctl."kernel.dmesg_restrict" = false;

  # boot.loader.timeout = lib.mkForce 5;
  system.nixos.distroName = "Tetonos";

  # programs.file-roller.enable = true;
  programs.system-config-printer.enable = true;
}
