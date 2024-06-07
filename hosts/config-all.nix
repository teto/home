# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, secrets, options, lib, ... }:

{

  imports = [
    ../nixos/accounts/root/root.nix
    ../nixos/accounts/teto/teto.nix
    ../nixos/profiles/ntp.nix
    ../nixos/profiles/neovim.nix
  ];

  boot.tmp.cleanOnBoot = true; # to clean /tmp on reboot
  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=2G
    '';
  # see https://github.com/NixOS/nixpkgs/issues/15293

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # time.timeZone = "Asia/Tokyo";

  # todo move to package sets
  environment.systemPackages = with pkgs; [
    ssh-to-age # useful everywhere
    man-pages # because man tcp should always be available
    moreutils # contains errno binary that can translate errnos
    ncurses.dev # for infocmp
    # termite.terminfo # broken on unstable to be able to edit over ssh
    kitty.terminfo # to be able to edit over ssh
  ] ++ (with pkgs; [
    # autoconf
    binutils
    curl
    fd # replaces 'find'
    just
    file
    fzf
    gitAndTools.gitFull # to get send-email
    gnumake
    htop
    lsof
    sudo
    wget
  ]);

  # TODO it appears in /etc/bashrc !
  environment.shellAliases = {

    # oftenly used programs {{{
    v = "nvim";
    c = "cat";
    # }}}
  };


  # variables set by PAM
  # https://wiki.archlinux.org/index.php/Environment_variables#Using_pam_env
  environment.sessionVariables = {
    # XDG_CONFIG_HOME="@{HOME}/.config";
    # XDG_CONFIG_HOME = "$HOME/.config";
    # xdg-settings set default-web-browser firefox.desktop
    # XDG_CACHE_HOME = "$HOME/.cache";
    # XDG_DATA_HOME = "$HOME/.local/share";
    # TODO Move to user config aka homemanager
  };

  environment.extraOutputsToInstall = [ "man" ];

  programs.less = {
    enable = true;
    # configFile = ;
    envVariables = {
      LESS = "-R --quit-if-one-screen";
      LESSHISTFILE = "$XDG_CACHE_HOME/less.hst";
      LESSHISTSIZE = "1000";
    };
  };

  # for nix-shell
  programs.bash = {
    completion.enable = true;
    shellInit = ''
      # set -o vi
      '';
  };

  security.sudo = {
    enable = true;
    # wheelNeedsPassword = true;
  };

}
