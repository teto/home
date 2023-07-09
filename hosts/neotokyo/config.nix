{ config, secrets, modulesPath, pkgs, lib, ... }:
# let
  # secrets = import ../../nixpkgs/secrets.nix;
# in
{
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


  # security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
	tmux
	# weechat
  ];

  services.gitolite.adminPubkey = secrets.gitolitePublicKey;

  networking.hostName = "neotokyo";

  system = {
    stateVersion = "23.05";
  };

}
