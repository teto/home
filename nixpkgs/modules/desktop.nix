{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  userNixpkgs = /home/teto/nixpkgs;
  nixosConfig = ./configuration.nix;
in
{

  imports = [
    ./config-all.nix

    ./ntp.nix
    ./network-manager.nix
    ./xserver.nix
    ./wireshark.nix
    ./wifi.nix

    # only if available
    # ./modules/jupyter.nix
  ];
  environment.homeBinInPath = true;

  environment.systemPackages = with pkgs; [
     stow
  ];

  networking.firewall.checkReversePath = false; # for nixops
  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  # allow-downgrade falls back when dnssec fails, "true" foces dnssec
  services.resolved.dnssec = "allow-downgrade";

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = false;
    # daemon.config
    support32Bit = true;
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "fr";

  # Select internationalisation properties.
  i18n = {
     defaultLocale = "fr_FR.UTF-8";
     # can generate problems for wireshark with Qt versions
     inputMethod = {
       enabled = "fcitx";
       fcitx.engines = with pkgs.fcitx-engines; [
         # mozc  # broken
         table-other # for arabic
         table-extra # for arabic
         # hangul
         m17n
     ];
     };

     # see https://github.com/NixOS/nixpkgs/issues/22895
     # consoleUseXkbConfig = "fr";
   };

   # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
   # todo find a good japanese font
   fonts = {
      fontDir.enable = true; # ?
      fonts = with pkgs; [
        ubuntu_font_family
        inconsolata # monospace
        noto-fonts-cjk # asiatic
        # nerdfonts
        # corefonts # microsoft fonts  UNFREE
        font-awesome_5
        source-code-pro
        dejavu_fonts
        # Adobe Source Han Sans
        sourceHanSansPackages.japanese
        fira-code-symbols # for ligatures
        # noto-fonts
      ];

      fontconfig= {
        enable=true;
        antialias=true; # some fonts can be disgusting else
        allowBitmaps = false; # ugly
        includeUserConf = true;
        defaultFonts = {
          # monospace = [ "" ];
          # serif = [ "" ];
          # sansSerif =
        };
      };
   };

  # udisks2 GUI
  # services.udisks2.enable = true;

  services.mpd = {
    enable = false; # TODO move to userspace
    # musicDirectory
  };


  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  services.greenclip.enable = true;

  nix.registry = {
    # nixpkgs.flake = ;
  };

  nix = {

    # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
    # daemonIONiceLevel = 3;
    # distributedBuilds = true;
    # TODO let it be set via channels ?
    # now with nix build -f channel:nixos-unstable
    # TODO use options.nix.nixPath.default ++
    nixPath = [
      "nixpkgs=${builtins.toString userNixpkgs}"
    ]
    ;

    # sshServe.enable = false;
    useSandbox = true;

    #  to keep build-time dependencies around => rebuild while being offline
    extraOptions = ''
      gc-keep-outputs = true
      # http-connections = 25 is the default
      http2 = true
      keep-derivations = true
      keep-failed = true
      show-trace = false
      builders-use-substitutes = true
    '';

    #       "https://teto.cachix.org"
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://jupyterwith.cachix.org"
    ];
    binaryCachePublicKeys = [
    ];

    trustedUsers = [ "root" "teto" ];

    # either use --option extra-binary-caches http://hydra.nixos.org/
    # handy to hack/fix around
    # readOnlyStore = false;
  };

  programs.gnome-disks.enable = false;

  # don't forget to run ulimit -c unlimited to get the actual coredump
  # then coredumpctl debug will launch gdb !
  # boot.kernel.sysctl."kernel.core_pattern" = "core"; to disable.
  # security.pam.loginLimits

  # this is slow
  documentation.nixos.enable = true;

  programs.system-config-printer.enable = true;

  users.users.teto = {
    shell = pkgs.zsh;
  };

}
