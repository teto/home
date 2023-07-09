{ config, flakeInputs, secrets, modulesPath, pkgs, lib, ... }:
# let
  # secrets = import ../../nixpkgs/secrets.nix;
# in
{
  networking.hostName = "neotokyo";

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
    ../../hm/profiles/zsh.nix

     # custom modules
     # ./home.nix
    # breaks build: doesnt like the "activation-script"
    # nova.hmConfigurations.dev
   ];
   home.stateVersion = "23.05";
 };


  # security.sudo.wheelNeedsPassword = true;

  # environment.systemPackages = with pkgs; [ ];

  services.gitolite.adminPubkey = secrets.gitolitePublicKey;


}
