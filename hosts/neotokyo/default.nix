{
  config,
  flakeSelf,
  secrets,
  modulesPath,
  pkgs,
  lib,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  autoloadedProfiles =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        root = ./.;
        include = [
          # wrong ?
          "home-manager/"
          "users/users/root.nix"

          "nix.nix"
          "services/harmonia.nix"
          "services/jellyfin.nix"
          "services/buildbot-nix.nix"
          "services/transmission.nix"
        ];
        exclude = [
          # "teto"
          # "users"
          # "home-manager" # exclude home-manager because intputs are not the same: it must be imported differently
          # "root"
        ];
      };

      inputs = args // {
        osConfig = config;
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{
  networking = {
    hostName = "neotokyo";
    domain = secrets.jakku.domain;

    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "25.05";

  # imported from gandhi ?
  # boot.initrd.kernelModules = [
  #   "xen-blkfront"
  #   "xen-tpmfront"
  #   "xen-kbdfront"
  #   "xen-fbfront"
  #   "xen-netfront"
  #   "xen-pcifront"
  #   "xen-scsifront"
  # ];

  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;
  };

  # some hardening
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];
  imports = [

    ./ovh.nix

    autoloadedProfiles
    ./disko-config.nix

    flakeSelf.nixosProfiles.systemd-on-failure-service

    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.nixosModules.teto-nogui
    flakeSelf.nixosModules.default-hm
    flakeSelf.nixosProfiles.ntp
    flakeSelf.nixosProfiles.nix-daemon

    # ./nix.nix
    ./hardware.nix
    ./sops.nix

    ./programs/msmtp.nix

    ./services/openssh.nix
    ./services/sshguard.nix
    ./services/gitolite.nix
    ./services/nextcloud.nix
    ./services/postgresqlBackup.nix
    ./services/nginx.nix
    ./services/immich.nix
    ./services/restic.nix
    ./services/llama-cpp.nix

    # ./services/jellyfin.nix

    # testing
    # ./services/vaultwarden.nix
    # ./services/linkwarden.nix
    ./services/hedgedoc.nix

    # ../../nixos/modules/hercules-ci-agents.nix

    flakeSelf.nixosProfiles.server
    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-master
    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-worker
  ];

  users = {

    # that's where we
    # users.jellyfin = {
    #   # that's where we gonna store our libraries
    #   createHome = true;
    # };
    # users.media = {
    #   # that's where we gonna store our libraries
    #   # todo create some directories like movies/music with tmpfiles.d ?
    #   createHome = true;
    # };

    users.teto = {
      # name = "Matt";
      extraGroups = [
        "nextcloud" # to be able to list files
        "backup" # to read
        "www" # to be able to write into the nginx read folder /var/www

        "media"
        # "jellyfin"
      ];
    };
    users.postgres = {
      extraGroups = [
        "backup"
        config.users.groups.backup.name
      ];
    };

    # might not be needed anymore ? for gitolite ?
    users.git = {
      isSystemUser = true;
      group = "www";
      home = "/home/git";
      createHome = true;
      shell = "${pkgs.git}/bin/git-shell";
      openssh.authorizedKeys.keys = config.users.users.teto.openssh.authorizedKeys.keys ++ [
        # your ssh key here
        # ../../perso/keys/id_rsa.pub
      ];
    };

    users.immich.extraGroups = [
      "video"
      "render"
    ];

    groups.media = {
      members = [
        # doesnt have a user ?
        # config.users.users.${config.services.jellyfin.user}.name
        config.users.users.${config.services.transmission.user}.name
        config.users.users.teto.name
      ];
    };
    groups.backup = { };
    groups.www = { };
  };

  # TODO create folders for transmission/jellyfin in /media or /home/media
  systemd.tmpfiles.rules = [
    # "d '${cfg.location}' 0700 postgres - - -"

    # 'backup' group hasread access only
    # 0740 would be better but for now just make it work
    # TODO check if this takes precedence over postgresqlBackup tmpfiles
    # "d '/var/backup/postgresql' 0750 postgres backup - -"
  ];

  # home-manager.users = {
  #
  #   teto = {
  #     # TODO it should load the whole folder
  #     imports = [
  #       # ./home-manager/users/teto/default.nix
  #       # flakeSelf.homeProfiles.neovim
  #       # flakeSelf.homeProfiles.yazi
  #     ];
  #   };
  # };

  boot.loader = {
    #    systemd-boot.enable = true;
    # efi.canTouchEfiVariables = true; # allows to run $ efi...
    # systemd-boot.editor = true; # allow to edit command line
    # because it's so hard to timely open VNC, we increase timetout
    timeout = lib.mkForce 15;
    # just to generate the entry used by ubuntu's grub
    # grub = {
    #   enable = true;
    #   useOSProber = false;
    #   # install to none, we just need the generated config
    #   # for ubuntu grub to discover
    #   # device = lib.mkForce "/dev/xvda";
    # };
  };

  # security.sudo.wheelNeedsPassword = true;
  security.sudo.execWheelOnly = true;

  environment.systemPackages = [
    # flakeSelf.inputs.transgression-tui.packages.${pkgs.stdenv.hostPlatform.system}.transgression-tui
    pkgs.tremc
    pkgs.restic # testing against restic
    pkgs.sops
    # pkgs.rustic # testing against restic
    pkgs.backblaze-b2-tetos
    pkgs.msmtp # to send mails
    pkgs.systemctl-tui
    pkgs.nixpkgs-review
    pkgs.zola # needed in the post-receive hook of the blog !
    pkgs.yazi
  ];

  # create a service to monitor new blog

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
