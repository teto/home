# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, ... } @ mainArgs:

let
  fzf = pkgs.fzf;
in
rec {

  imports = [
      ./account-teto.nix
      ./ntp.nix
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
    manpages  # because man tcp should always be available
    moreutils # contains errno binary that can translate errnos
    ncurses.dev # for infocmp
    # termite.terminfo # broken on unstable to be able to edit over ssh
    kitty.terminfo # to be able to edit over ssh
    utillinux # for lsns (namespace listing)
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
     # pkgconfig
     # pstree

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

      # kernel aliases {{{
        # nix messes up the escaping I think
        # kernel_makeconfig=''
        #   nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
        #   '';
  # kernel_xconfig=''
    # nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})' --command 'make menuconfig KCONFIG_CONFIG=$PWD/build/.config'
  # '';
  # kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"
  # }}}
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

  # on master it is disabled
  documentation.man.enable = true;

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
    enable= true;
    zsh-autoenv.enable = false;
    enableCompletion = true;
    autosuggestions.enable = false;
    syntaxHighlighting.enable = false;
    shellAliases= environment.shellAliases // {
    };
    # goes to /etc/zshenv
  shellInit = ''
    '';

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
  interactiveShellInit = ''
  #   # To see the key combo you want to use just do:
  #   # Don't try to bind CTRL Q / CTRL S !!
  #   # cat > /dev/null
  #   # And press it


    bindkey -e
    bindkey -v   # Default to standard vi bindings, regardless of editor string
  '';

  #   zle -N edit-command-line

  #   # Press ESC-v to edit current line in your favorite $editor
  #   bindkey -M vicmd v edit-command-line
  #   # bindkey '^V' edit-command-line
  #   bindkey -r "^G" # was bound to list-expand I don't know where/why
  #   # bindkey '^G' push-line-or-edit
  #   # TODO doesn't work because it s overriden afterwards apparently
  #   # home-manager should have this ?
  #   # . "${fzf}/share/fzf/completion.zsh"
  #   # . "${fzf}/share/fzf/key-bindings.zsh"


};

  # for nix-shell
  programs.bash = {
    enableCompletion = true;
    shellInit=''
      # set -o vi
    '';
  };

  # to get manpages
  documentation.enable = true;
  # set it to true to help
  documentation.nixos.includeAllModules = false;

  users.defaultUserShell = pkgs.zsh;

  nixpkgs = {
    config = {
  #     allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "vscode-extension-ms-vsliveshare-vsliveshare"
        "sublimetext3"
        "slack"
        "vscode"
        "steam"
        "steam-original"
        "steam-runtime"
      ];
  #     permittedInsecurePackages = [
  #         # "webkitgtk-2.4.11"
  #     ];
    };
  };
  environment.etc."inputrc".source = ../../config/inputrc;

  security.sudo = {
    enable = true;
    # wheelNeedsPassword = true;
  };

  system = {
    stateVersion = "21.11";
  };

}
