{ config, flakeInputs, secrets, modulesPath, pkgs, lib, ... }:
# let
  # secrets = import ../../nixpkgs/secrets.nix;
# in
{
 networking = {
   hostName = "neotokyo";
  firewall = {
     enable = true;
   };
  };

  system.stateVersion = "23.05";

  # imported from gandhi ?
    boot.initrd.kernelModules = [
      "xen-blkfront" "xen-tpmfront" "xen-kbdfront" "xen-fbfront"
      "xen-netfront" "xen-pcifront" "xen-scsifront"
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
    # ./hardware.nix
    ./openssh.nix
    ./sops.nix

    # to get the first iteration going on
    ./nextcloud.nix

    ../common-server.nix
    # ../../nixos/modules/gitolite.nix
    # ../../nixos/modules/hercules-ci-agents.nix

    ../../nixos/profiles/ntp.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/neovim.nix

    # ../modules/blog.nix

    # just to help someone on irc
    # <nixpkgs/nixos/modules/profiles/hardened.nix>

  ];

  home-manager.users.root = {
   imports = [
    ../../hm/profiles/neovim.nix
    ../desktop/root/ssh-config.nix
   ];

   home.stateVersion = "23.05";
  };

 home-manager.users.teto = {
   # TODO it should load the whole folder
   imports = [
     # ../desktop/teto/
    # ../../hm/profiles/teto/common.nix
    ../../hm/profiles/common.nix
    ../../hm/profiles/zsh.nix
    ../../hm/profiles/neovim.nix

     # custom modules
     # ./home.nix
    # breaks build: doesnt like the "activation-script"
    # nova.hmConfigurations.dev
   ];
   home.stateVersion = "23.05";
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
      useOSProber = true;
      # install to none, we just need the generated config
      # for ubuntu grub to discover
      device = lib.mkForce "/dev/xvda";
    };
  };

  # security.sudo.wheelNeedsPassword = true;

  # environment.systemPackages = with pkgs; [ ];

  services.gitolite.adminPubkey = secrets.gitolitePublicKey;


}
