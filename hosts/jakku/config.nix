{ config, modulesPath, pkgs, lib, ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;
in
{

  imports = [
    # for gandi

    "${modulesPath}/virtualisation/openstack-config.nix"
    ./hardware.nix
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

  nix.settings = {
    trustedUsers = [ "root" "teto" ];
  };

}
