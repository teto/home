# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  secrets,
  options,
  lib,
  ...
}:

{

  imports = [
    ../nixos/accounts/root/root.nix
    ../nixos/accounts/teto/teto.nix
    ../nixos/profiles/ntp.nix
    # ../nixos/profiles/neovim.nix
  ];

  boot.tmp.cleanOnBoot = true; # to clean /tmp on reboot

  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=2G
  '';

  # todo move to package sets
  environment.systemPackages =
    with pkgs;
    [
      ssh-to-age # useful everywhere
      man-pages # because man tcp should always be available
      # moreutils # contains errno binary that can translate errnos
      ncurses.dev # for infocmp
      # termite.terminfo # broken on unstable to be able to edit over ssh
      kitty.terminfo # to be able to edit over ssh
    ]
    ++ (with pkgs; [
      # autoconf
      binutils
      curl
      fd # replaces 'find'
      file
      fzf
      # htop
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
  environment.sessionVariables =
    {
    };

  environment.extraOutputsToInstall = [ "man" ];

  programs.less = {
    enable = true;
    # configFile = ;
    envVariables = {
      LESS = "-R --quit-if-one-screen";
      # LESSHISTFILE = "''${XDG_CACHE_HOME:-~/.cache}/less.hst";
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
