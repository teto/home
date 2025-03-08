{
  config,
  flakeSelf,
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
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";

  # imported from gandhi ?
  boot.initrd.kernelModules = [
    "xen-blkfront"
    "xen-tpmfront"
    "xen-kbdfront"
    "xen-fbfront"
    "xen-netfront"
    "xen-pcifront"
    "xen-scsifront"
  ];
  # This is to get a prompt via the "openstack console url show" command
  systemd.services."getty@tty1" = {
    enable = lib.mkForce true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Restart = "always";
  };

  imports = [
    # for gandi
    "${modulesPath}/virtualisation/openstack-config.nix"

    flakeSelf.nixosModules.teto-nogui
    flakeSelf.nixosModules.default-hm
    flakeSelf.nixosModules.neovim
    flakeSelf.nixosModules.ntp
    flakeSelf.nixosModules.nix-daemon

    # ./hardware.nix
    ./services/openssh.nix
    ./sops.nix

    # to get the first iteration going on
    ./services/gitolite.nix
    ./services/nextcloud.nix
    ./services/postgresqlBackup.nix
    ./services/nginx.nix
    ./services/immich.nix

    # ../../nixos/modules/hercules-ci-agents.nix
    # ../../nixos/profiles/docker-daemon.nix

    flakeSelf.nixosModules.server

    # just to help someone on irc
    # <nixpkgs/nixos/modules/profiles/hardened.nix>

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
        flakeSelf.homeProfiles.neovim
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
    grub = {
      enable = true;
      useOSProber = false;
      # install to none, we just need the generated config
      # for ubuntu grub to discover
      device = lib.mkForce "/dev/xvda";
    };
  };

  # security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = [
    pkgs.neovim
    pkgs.zola # needed in the post-receive hook of the blog !
    pkgs.yazi
  ];

  # create a service to monitor new blog
  # systemd.

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
