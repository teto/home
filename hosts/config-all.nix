# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, ... }:

let
  fzf = pkgs.fzf;
in
rec {

  imports = [
      ./account-teto.nix
      ../modules/ntp.nix
      ../nixos/profiles/neovim.nix

  ];


  boot.cleanTmpDir = true; # to clean /tmp on reboot
  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=2G
  '';
  # see https://github.com/NixOS/nixpkgs/issues/15293

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # time.timeZone = "Asia/Tokyo";
  # set to false on windows machines else it messes up
  time.hardwareClockInLocalTime = false; # by default false
  # services.tzupdate.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages  # because man tcp should always be available
    moreutils # contains errno binary that can translate errnos
    ncurses.dev # for infocmp
    # termite.terminfo # broken on unstable to be able to edit over ssh
    kitty.terminfo # to be able to edit over ssh
    util-linux # for lsns (namespace listing)
  ] ++ (with pkgs; [
     automake
     # autoconf
     binutils
     curl
     fd  # replaces 'find'
     file
	 fzf
     lsof
	 # gawk
     gitAndTools.gitFull # to get send-email
	 # git-extras # does not find it (yet)
     gnum4 # hum
     gnupg
     gnumake
     htop

     # ipsecTools # does it provide ipsec ?

     # for fuser, useful when can't umount a directory
     # https://unix.stackexchange.com/questions/107885/busy-device-on-umount
     psmisc
     # pv # monitor copy progress
     ranger
     rsync
     ripgrep
     sudo
	 unzip
     # vifm
     vim
     wget
  ]);

   # TODO it appears in /etc/bashrc !
   environment.shellAliases = {
      nix-stray-roots=''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)"'';
      nixpaste="curl -F \"text=<-\" http://nixpaste.lbr.uno";
      ".."="cd ..";
      "..."="cd ../..";

  # oftenly used programs {{{
        v="nvim";
        c="cat";
        r="ranger";
  # }}}
   };


  # variables set by PAM
  # https://wiki.archlinux.org/index.php/Environment_variables#Using_pam_env
  environment.sessionVariables = {
    # XDG_CONFIG_HOME="@{HOME}/.config";
    XDG_CONFIG_HOME="$HOME/.config";
    EDITOR="nvim";
    # xdg-settings set default-web-browser firefox.desktop
    XDG_CACHE_HOME="$HOME/.cache";
    XDG_DATA_HOME="$HOME/.local/share";
    # TODO Move to user config aka homemanager
    # HISTFILE="'${XDG_CACHE_HOME}/bash_history";
    # LESS=""; # options to pass to less automatically
  };
  environment.extraOutputsToInstall = [ "man" ];
  # environment.variables = {
  # };

  # stick to sh as it's shell independant
  # environment.extraInit = builtins.readFile ../../config/zsh/init.sh;

  programs.less = {
    enable = true;
    # configFile = ;
    envVariables = {
      LESS = "-R --quit-if-one-screen";
      LESSHISTFILE = "$XDG_CACHE_HOME/less.hst";
      LESSHISTSIZE = "1000";
    };
  };

  programs.zsh = {
    enable=true;
    zsh-autoenv.enable = false;
    enableCompletion = true;
    enableGlobalCompInit = false;
    # enableAutosuggestions = true;
    autosuggestions = {
      enable = false;
      # highlightStyle = ""
    };
    # promptInit
    # vteIntegration = false;
    syntaxHighlighting.enable = false;
    shellAliases= environment.shellAliases // {
    };
    # goes to /etc/zshenv
    # shellInit = ''
    # '';

  # todo make available for zsh too
  # use FZF_PATH="$(fzf-share)" to do it dynamically
  #   bindkey "^K"      kill-whole-line                      # ctrl-k
  #   bindkey "^A"      beginning-of-line                    # ctrl-a
  #   bindkey "^E"      end-of-line                          # ctrl-e
  #   bindkey "[B"      history-search-forward               # down arrow
  #   bindkey "[A"      history-search-backward              # up arrow
  #   bindkey "^D"      delete-char                          # ctrl-d
  #   bindkey "^F"      forward-char                         # ctrl-f
  #   bindkey "^B"      backward-char                        # ctrl-b
  # bindkey -e
  # bindkey -v   # Default to standard vi bindings, regardless of editor string
  # interactiveShellInit = ''
  # #   # To see the key combo you want to use just do:
  # #   # Don't try to bind CTRL Q / CTRL S !!
  # #   # cat > /dev/null
  # #   # And press it


  };


  # environment.etc.zshrc.text = lib.mkMerge [
		# (lib.mkBefore "zmodload zsh/zprof")
		# (lib.mkAfter "zprof")
  #   ];


  # for nix-shell
  programs.bash = {
    enableCompletion = true;
    shellInit=''
      # set -o vi
    '';
  };


  # users.defaultUserShell = pkgs.zsh;

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "Oracle_VM_VirtualBox_Extension_Pack"
        "ec2-api-tools"
        "google-chrome"
        "slack"
        "steam"
        "steam-original"
        "steam-runtime"
        "steam-run"
        "sublimetext3"
        "vscode"
        "vscode-extension-ms-vsliveshare-vsliveshare"
        "zoom"
      ];
    };
  };
  environment.etc."inputrc".source = ../config/inputrc;

  security.sudo = {
    enable = true;
    # wheelNeedsPassword = true;
  };

  system = {
    stateVersion = "21.11";
  };

}
