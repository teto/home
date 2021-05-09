{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  userNixpkgs = /home/teto/nixpkgs;
in
{

  imports = [
    ./config-all.nix

    ./ntp.nix
    ./network-manager.nix
    ./wireshark.nix
    ./wifi.nix
    ../profiles/neovim.nix

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

  # console.font = "Lat2-Terminus16";
  # console.keyMap = "fr";

  # Select internationalisation properties.
  i18n = {
     # defaultLocale = "fr_FR.UTF-8";
     # until we can configure it in fcitx
     defaultLocale = "en_US.UTF-8";
     # can generate problems for wireshark with Qt versions
     inputMethod = {
       # enabled = "fcitx5";
       enabled = null;
       # enabled = "fcitx";
       # i18n.inputMethod.package
       fcitx.engines = with pkgs.fcitx-engines; [
         mozc  # broken
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
        cache32Bit = false; # defualt false
        defaultFonts = {
          # monospace = [ "" ];
          # serif = [ "" ];
          # sansSerif =
        };
      };
   };

  systemd.packages = [
    pkgs.deadd-notification-center
  ];

  # udisks2 GUI
  # services.udisks2.enable = true;

  services.mpd = {
    enable = false; # TODO move to userspace
    # musicDirectory
  };

  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;

  services.greenclip = let
    # myGreenclip = with pkgs; haskell.lib.unmarkBroken haskell.packages.ghc884.greenclip;
  in {
    enable = true;
    # package = myGreenclip;
  };

  nix = {

    # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
    # daemonIONiceLevel = 3;
    nixPath = [
      "nixpkgs=${builtins.toString userNixpkgs}"
    ]
    ;

    # either use --option extra-binary-caches http://hydra.nixos.org/
    # handy to hack/fix around
    # readOnlyStore = false;
  };

  programs.gnome-disks.enable = false;

  # don't forget to run ulimit -c unlimited to get the actual coredump
  # then coredumpctl debug will launch gdb !
  # boot.kernel.sysctl."kernel.core_pattern" = "core"; to disable.
  # security.pam.loginLimits
  systemd.coredump.enable = true;

  # see 
  systemd.coredump.extraConfig = ''
    #Storage=external
    #Compress=yes
    ProcessSizeMax=20G
    ExternalSizeMax=20G
    #JournalSizeMax=767M
    #MaxUse=
    #KeepFree=
    '';

    # users.motd = 
  security.pam.loginLimits = [
    {
      domain = "teto";
      type = "soft";
      item = "core";
      value = "unlimited";
    }
  ];

# nixpkgs/modules/config-all.nix|262 col 15| environment.etc."inputrc".source = ../../config/inputrc;
  environment.etc."security/limits.conf".text = ''
    #[domain]        [type]  [item]  [value]
    teto  soft  core  unlimited
  '';
  # teto  hard  core  unlimited

  # systemd.services."systemd-coredump".serviceConfig.ProtectHome = false;
  # systemd.services."systemd-coredump@".serviceConfig.ProtectHome = false;
  # environment.etc."systemd/system/systemd-coredump@.service.d/override.conf".text = ''
  #   ProtectHome=no
  # '';
  # this is slow
  documentation.nixos.enable = true;

  # programs.file-roller.enable = true;

  programs.system-config-printer.enable = true;

  users.users.teto = {
    shell = pkgs.zsh;
  };

}
