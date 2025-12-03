{
  config,
  flakeSelf,
  secrets,
  modulesPath,
  pkgs,
  lib,
  ...
}:
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

  imports = [

    # ONE OR THE OTHER
    # for gandi
    # ./gandi.nix
    ./ovh.nix

    ./disko-config.nix

    ../../nixos/profiles/systemd-on-failure-service.nix

    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.nixosModules.teto-nogui
    flakeSelf.nixosModules.default-hm
    # flakeSelf.nixosModules.neovim
    flakeSelf.nixosModules.ntp
    flakeSelf.nixosModules.nix-daemon

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

    # testing
    ./services/linkwarden.nix
    ./services/hedgedoc.nix

    # ../../nixos/modules/hercules-ci-agents.nix

    flakeSelf.nixosModules.server
  ];

  # virtualisation.docker.enable = true;

  users = {

    users.teto = {
      # name = "Matt";
      extraGroups = [
        "nextcloud" # to be able to list files
        "backup" # to read
        "www" # to be able to write into the nginx read folder /var/www
      ];
    };
    users.postgres = {
      extraGroups = [
        "backup"
        config.users.groups.backup.name
      ];
    };

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
    groups.backup = { };
    groups.www = { };
  };

  home-manager.users = {
    root = {
      imports = [
        flakeSelf.homeProfiles.neovim
        (
          { ... }:
          {
            # why do i need that already ? for the nix-daemon ?
            programs.ssh.enable = true;
          }
        )

      ];
    };
    teto = {
      # TODO it should load the whole folder
      imports = [
        ./home-manager/users/teto/default.nix
        flakeSelf.homeModules.teto-nogui
        # flakeSelf.homeProfiles.neovim
        # flakeSelf.homeProfiles.yazi
      ];
    };
  };


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

  environment.systemPackages = [
    pkgs.msmtp # to send mails
    pkgs.neovim
    pkgs.nixpkgs-review
    pkgs.zola # needed in the post-receive hook of the blog !
    pkgs.yazi
  ];

  # create a service to monitor new blog

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
