# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  flakeSelf,
  secrets,
  options,
  lib,
  ...
}:

{

  imports = [
    ../accounts/root/root.nix
    ../accounts/teto/teto.nix
    flakeSelf.nixosProfiles.ntp
    # ../nixos/profiles/neovim.nix
  ];

  boot.tmp.cleanOnBoot = true; # to clean /tmp on reboot

  # todo move to package sets
  environment.systemPackages =
    with pkgs;
    [
      # ssh-to-age # useful everywhere
      man-pages # because man tcp should always be available
      ncurses.dev # for infocmp
      kitty.terminfo # to be able to edit over ssh
    ]
    ++ (with pkgs; [
      # autoconf
      curl
      fd # replaces 'find'
      file
      # lsof
      # sudo
    ]);

  # TODO it appears in /etc/bashrc !
  environment.shellAliases = {
    # oftenly used programs {{{
    v = "nvim";
    c = "cat";
    st = "systemctl-tui";
    jctl = "journalctlb -b0 -r";
    # }}}

    # git {{{
    y = "yazi";
    g="git";
# }}}
  };

  # variables set by PAM
  # https://wiki.archlinux.org/index.php/Environment_variables#Using_pam_env
  environment.sessionVariables = {
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

      # disable flow control see https://unix.stackexchange.com/questions/12107/how-to-unfreeze-after-accidentally-pressing-ctrl-s-in-a-terminal/12108#12108
      stty -ixon
    '';
  };

  # todo might not be necessary on server ?
  programs.zsh = {
    enable = true;

    # autosuggestions.async
    interactiveShellInit = ''
      stty -ixon
    '';
  };

  security.sudo = {
    enable = true;
    # wheelNeedsPassword = true;
  };
}
