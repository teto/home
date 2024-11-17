{
  config,
  flakeSelf,
  flakeInputs,
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

    flakeSelf.nixosModules.neovim
    flakeSelf.nixosModules.ntp

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

    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/server.nix

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
      ];
    };

    users.postgres = {
      extraGroups = [
        "backup" # to read
      ];
    };

    groups.backup = { };
  };

  home-manager.users = {
    root = {
      imports = [

        flakeSelf.homeModules.neovim
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
        flakeSelf.homeModules.neovim
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

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
