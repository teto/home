{ config, lib, pkgs, ... }:
{

  imports = [
    ../../hosts/config-all.nix

    ../../nixos/profiles/ntp.nix
    ./desktop/programs/wireshark.nix
    ../../nixos/modules/network-manager.nix
    # ../../nixos/profiles/librenms.nix

    ./desktop/programs/zsh.nix
    ./gnome.nix
    ./neovim.nix
    ./pipewire.nix
    ./sops.nix

    # only if available
    # ./modules/jupyter.nix
  ];

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

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
  documentation.doc.enable = true; # builds html doc, slow
  documentation.info.enable = false;

  environment.systemPackages = with pkgs; [
    stow
  ];

  security.pam.services.swaylock = {};

  # networking.firewall.checkReversePath = false; # for nixops
  # networking.firewall.allowedUDPPorts = [ 631 ];
  # networking.firewall.allowedTCPPorts = [ 631 ];

  hardware = {
    # enableAllFirmware =true;
    enableRedistributableFirmware = true;
    sane.enable = true;
    # High quality BT calls
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva
        # trying to fix `WLR_RENDERER=vulkan sway`
        vulkan-validation-layers  # broken
      ];

    };
  };

  # console.font = "Lat2-Terminus16";
  # console.keyMap = "fr";

  # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
  # todo find a good japanese font
  fonts = {
    fontDir.enable = true; # ?
    packages = with pkgs; [
      ubuntu_font_family
      inconsolata # monospace
      noto-fonts-cjk # asiatic
      nerdfonts # otherwise no characters
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

      # corefonts # microsoft fonts  UNFREE
      font-awesome_5
      source-code-pro
      dejavu_fonts
      # Adobe Source Han Sans
      source-han-sans #sourceHanSansPackages.japanese
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
        # monospace = [ "" ];
        # serif = [ "" ];
        # sansSerif =
      };
    };
  };

  # systemd.packages = [ ];

  programs.browserpass.enable = true;

  nix = {

    # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
    # daemonIONiceLevel = 3;
    nixPath = [
      "nixpkgs=flake:/home/teto/nixpkgs"
    ];

    # either use --option extra-binary-caches http://hydra.nixos.org/
    # handy to hack/fix around
    # readOnlyStore = false;
  };

  # programs.gnome-disks.enable = false;

  # don't forget to run ulimit -c unlimited to get the actual coredump
  # check thos comment to setup user ulimits https://github.com/NixOS/nixpkgs/issues/159964#issuecomment-1252682060
  # systemd.services."user@1000".serviceConfig.LimitNOFILE = "32768";
  security.pam.loginLimits = [
   # 
   # to avoid "Bad file descriptor" and "Too many open files" situations
   { domain = "*"; item = "nofile"; type = "-"; value = "32768"; }
   { domain = "*"; item = "memlock"; type = "-"; value = "32768"; }
  ];
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

  # users.motd = 
  # security.pam.loginLimits = [
  #   {
  #     domain = "teto";
  #     type = "soft";
  #     item = "core";
  #     value = "unlimited";
  #   }
  #   {
  #     domain = "*";
  #     type = "hard";
  #     item = "memlock";
  #     value = "256";
  #   }
  # ];


  environment.etc."security/limits.conf".text = ''
    #[domain]        [type]  [item]  [value]
    teto  soft  core  unlimited
    teto  soft  memlock 128
    *  hard  memlock  256
    @audio   -  nice     -20
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

  # system.activationScripts.report-nixos-changes = ''
  #   PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
  #   nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  # '';

#   system.activationScripts.report-home-manager-changes = ''
#     PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
#     nvd diff $(ls -dv /nix/var/nix/profiles/per-user/teto/home-manager-*-link | tail -2)
#   '';

}
