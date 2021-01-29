{ config, pkgs, lib, ... }:
let
  secrets = import ../secrets.nix;
in
{

  imports = [
      ./hardware-iij-gitolite.nix
      ./common-server.nix
      ../modules/gitolite.nix
      ../modules/openssh.nix
      ../modules/hercules-ci-agents.nix
      ../modules/nextcloud.nix
      # ../modules/blog.nix

      # just to help someone on irc
       # <nixpkgs/nixos/modules/profiles/hardened.nix>

  ];

  services.nextcloud.hostName = secrets.gitolite_server.hostname;

  environment.systemPackages = with pkgs; [
    tmux
    weechat
  ];

 # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
  services.gitolite.adminPubkey = secrets.gitolitePublicKey;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "gitolite";

  networking.defaultGateway = secrets.gateway;
  networking.nameservers = secrets.nameservers;

  networking.interfaces.ens192 = secrets.gitolite_server.interfaces;

  # allow to fetch mininet from the host machine

  nix = {
    trustedUsers = [ "root" "teto" ];
    binaryCaches = [
      "https://cache.nixos.org/"
    ];

    # turn off to use hardened profile
    useSandbox = true;
  };


  # Fix problem with sudo
  # https://github.com/NixOS/nixops/issues/931
  system.activationScripts.nixops-vm-fix-931 = {
    text = ''
      if ls -l /nix/store | grep sudo | grep -q nogroup; then
        mount -o remount,rw  /nix/store
        chown -R root:nixbld /nix/store
      fi
    '';
    deps = [];
  };
}
