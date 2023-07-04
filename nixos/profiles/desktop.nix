{ config, lib, pkgs, ... }:
# let
# secrets = import ./secrets.nix;
# userNixpkgs = /home/teto/nixpkgs;
# in
{

  imports = [
    ../../hosts/config-all.nix

    ../../nixos/profiles/ntp.nix
    ../../modules/network-manager.nix
    ../../modules/wireshark.nix
    ../../modules/wifi.nix

    ./zsh.nix
    ./gnome.nix
    ./wayland.nix
    ./neovim.nix
    ./pipewire.nix
    ./sops.nix

    # only if available
    # ./modules/jupyter.nix
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "Oracle_VM_VirtualBox_Extension_Pack"
        "ec2-api-tools"
        "jiten"  # japanese software recognition tool
        "google-chrome"
        "slack"
        "steam"
        "steam-original"
        "steam-runtime"
        "steam-run"
        "sublimetext3"
        "vscode"
        "vscode-extension-ms-vsliveshare-vsliveshare"
        "xmind"
        "zoom"
      ];
    };
  };

  xdg.portal = {
   enable = true; 
   xdgOpenUsePortal = true; 
  };
  environment.homeBinInPath = true;

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

  # allow-downgrade falls back when dnssec fails, "true" foces dnssec
  services.resolved.dnssec = "allow-downgrade";

  hardware = {
    # enableAllFirmware =true;
    enableRedistributableFirmware = true;
    sane.enable = true;
    # High quality BT calls
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      # hsphfpd.enable = false; # conflicts with pipewire
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  # console.font = "Lat2-Terminus16";
  # console.keyMap = "fr";

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
      source-han-sans #sourceHanSansPackages.japanese
      fira-code-symbols # for ligatures
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

  systemd.packages = [
    # pkgs.deadd-notification-center

  ];

  # udisks2 GUI
  # services.udisks2.enable = true;

  # seemingly working for chromium only, check for firefox
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
  # security.pam.loginLimits = [
  #  { domain = "*"; item = "nofile"; type = "-"; value = "32768"; }
  #  { domain = "*"; item = "memlock"; type = "-"; value = "32768"; }
  # ];
  # then coredumpctl debug will launch gdb !
  # boot.kernel.sysctl."kernel.core_pattern" = "core"; to disable.
  # security.pam.loginLimits
  systemd.coredump.enable = true;

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

  users.users.teto = {
    shell = pkgs.zsh;
  };

  # system.activationScripts.report-nixos-changes = ''
  #   PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
  #   nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  # '';

#   system.activationScripts.report-home-manager-changes = ''
#     PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
#     nvd diff $(ls -dv /nix/var/nix/profiles/per-user/teto/home-manager-*-link | tail -2)
#   '';

}
