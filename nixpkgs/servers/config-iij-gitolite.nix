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
      ../modules/nextcloud.nix
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

  networking.interfaces.ens3 = secrets.gitolite_server.interfaces;

  # allow to fetch mininet from the host machine

  nix = {
    trustedUsers = [ "root" "teto" ];
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];

  };

  nixpkgs.overlays = [
    import ../../config/nixpkgs/overlays/neovim.nix
  ];

  home-manager.users.teto = { ... }:
  {
    # fails for now
    imports = [ ../home-common.nix ];
    xdg.configFile."weechat/irc.conf".source = ../../config/weechat/irc.conf;

    programs.zsh.shellInit = ''
      ZSH_DISABLE_COMPFIX=true
    '';
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

  # nix.  = ''
  #   require-sigs = false
  #   trusted-substituters = s3://<bucket>?region=us-west-1
  #   extra-substituters = s3://<bucket>?region=us-west-1
  # '';
}
