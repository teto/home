{ config, modulesPath, pkgs, lib, ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;
in
{

  imports = [
    # for gandi

    "${modulesPath}/virtualisation/openstack-config.nix"
    # ./hardware.nix
    ../common-server.nix
    ../../modules/gitolite.nix
    # ../../modules/hercules-ci-agents.nix
    ../../modules/nextcloud.nix
    ../../modules/ntp.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/neovim.nix
    ../../nixos/profiles/openssh.nix

    # ../modules/blog.nix

    # just to help someone on irc
    # <nixpkgs/nixos/modules/profiles/hardened.nix>

  ];

  sops.defaultSopsFile = ./secrets.yaml;
  # This is using an age key that is expected to already be in the filesystem
  # TODO use ssh key instead
  #  upload it with 
  # scp -F ssh_config "${SOPS_AGE_KEY_FILE}" hybrid-dev:/tmp/key.txt
  # then we move the file
  # ssh -F ssh_config hybrid-dev sudo mv /tmp/key.txt /var/lib/sops-nix/key.txt

  # sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = false;

  services.nextcloud.hostName = secrets.jakku.hostname;
  security.acme.acceptTerms = true;

  environment.systemPackages = with pkgs; [
    tmux
    # weechat
  ];

  services.gitolite.adminPubkey = secrets.gitolitePublicKey;

  networking.hostName = "jakku";


  # networking.defaultGateway = secrets.gateway;
  # networking.nameservers = secrets.nameservers;

  # networking.interfaces.ens192 = secrets.gitolite_server.interfaces;

  # allow to fetch mininet from the host machine

  # nix.settings = {
  #   trustedUsers = [ "root" "teto" ];
  # };

}
