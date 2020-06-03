# sudo nixos-rebuild  -I nixos-config=/home/teto/configuration.nix switch
#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, ... } @ mainArgs:

let
  fzf = pkgs.fzf;
in
  # Check if custom vars are set
  # assert mySecrets.user            != "";
  # assert mySecrets.passwd          != "";
  # assert mySecrets.hashedpasswd    != "";
  # assert mySecrets.cifs            != "";
  # assert mySecrets.hostname        != "";
  # assert mySecrets.smbhome         != "";
  # assert mySecrets.smboffice       != "";
  # assert mySecrets.ibsuser         != "";
  # assert mySecrets.ibspass         != "";
  # assert mySecrets.ibsip != "";
rec {

  imports = [
      ./account-teto.nix
      ./ntp.nix
  ];
  # kernelModules are forcibly loaded
  # availableKernelModules are just available, and udev will auto-load them as needed


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
    termite.terminfo # to be able to edit over ssh
    kitty.terminfo # to be able to edit over ssh
    utillinux # for lsns (namespace listing)
  ] ++ (with pkgs; [
     automake
     # autoconf
     autojump
     binutils
     # cmake
     curl
     fd  # replaces 'find'
     file
	 fzf
     # lgogdownloader
     # libtool
     lsof
	 # gawk
     gitAndTools.gitFull # to get send-email
	 # git-extras # does not find it (yet)
     gnum4 # hum
     gnupg
     gnumake
     htop

     # ipsecTools # does it provide ipsec ?
     # neovim # TODO remake a custom one
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
     # tig
	 unzip
     # vifm
     vim
     wget
     # zsh
  ]);

   # TODO it appears in /etc/bashrc !
   environment.shellAliases = {
      # git variables {{{
      gl="git log";
      gs="git status";
      gd="git diff";
      ga="git add";
      gc="git commit";
      gcm="git commit -m";
      gca="git commit -a";
      gb="git branch";
      gch="git checkout";
      grv="git remote -v";
      gpu="git pull";
      gcl="git clone";
      gta="git tag -a -m";
      gbr="git branch";
      # }}}
      # nix aliases {{{
      nxi="nix-env -iA";
      nxu="nix-env -e";
      nxs="nix-shell -A";
      nxp="nixops ";
      # }}}
      nix-stray-roots=''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)"'';
# lib.escapeShellArg fails
      nixpaste="curl -F \"text=<-\" http://nixpaste.lbr.uno";
    ".."="cd ..";
    "..."="cd ../..";


    # kernel aliases {{{
      # nix messes up the escaping I think
      kernel_makeconfig=''
        nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
        '';
kernel_xconfig=''
  nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})' --command 'make menuconfig KCONFIG_CONFIG=$PWD/build/.config'
'';
# kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"
# }}}

# oftenly used programs {{{
      v="nvim";
      c="cat";
      r="ranger";
# }}}
   };


  # variables set by PAM
  environment.sessionVariables = {};
  environment.extraOutputsToInstall = [ "man" ];
  environment.variables = {
    EDITOR="nvim";
    BROWSER="qutebrowser";

    # todo 
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_CACHE_HOME="$HOME/.cache";
    XDG_DATA_HOME="$HOME/.local/share";
    # TODO Move to user config aka homemanager
    HISTFILE="$XDG_CACHE_HOME/bash_history";
    LESS=""; # options to pass to less automatically
  };

  # stick to sh as it's shell independant
  environment.extraInit = builtins.readFile ../../config/zsh/init.sh;

  # environment.gnome3.excludePackages = [];
  # security.initialRootPassword = "!";

  # Enable automatic discovery of the printer (from other linux systems with avahi running)
  # services.avahi = {
  #   enable = true;
  #   publish.enable = true;
  #   publish.userServices = true;
  # };

  # option to explore ?
  # services.opensmtpd = {
  #   enable= false;
  # };

  # on master it is
  documentation.man.enable = true;

  # programs.light.enable = true;

  programs.less = {
    enable = true;
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
    autosuggestions.enable = true;
    syntaxHighlighting.enable = false;
	ohMyZsh = {
		enable = false;
	  # theme
	};
    shellAliases= environment.shellAliases // {
      se="sudoedit";
      # to delete files
      # todo escape it else it fails
      # clean_orig="find . -name '*.orig' -delete";
    # ++ [
  # alias -s json=nvim
  # alias -s Vagrantfile=nvim
  # alias -s py=python3
  # alias -s rb=ruby
  # alias -s png=sxiv
  # alias -s jpg=xdg-open
  # alias -s gif=xdg-open
  # alias -s avi=mpv
  # alias -s mp3=mocp
  # alias -s pdf=xdg-open
  # alias -s doc=xdg-open
  # alias -s docx=xdg-open
    };
    # goes to /etc/zshenv
  shellInit = ''
    '';

  # todo make available for zsh too
  # use FZF_PATH="$(fzf-share)" to do it dynamically
  interactiveShellInit = ''
    # To see the key combo you want to use just do:
    # Don't try to bind CTRL Q / CTRL S !!
    # cat > /dev/null
    # And press it

    bindkey "^K"      kill-whole-line                      # ctrl-k
    bindkey "^A"      beginning-of-line                    # ctrl-a
    bindkey "^E"      end-of-line                          # ctrl-e
    bindkey "[B"      history-search-forward               # down arrow
    bindkey "[A"      history-search-backward              # up arrow
    bindkey "^D"      delete-char                          # ctrl-d
    bindkey "^F"      forward-char                         # ctrl-f
    bindkey "^B"      backward-char                        # ctrl-b

    bindkey -v   # Default to standard vi bindings, regardless of editor string

    zle -N edit-command-line

    # Press ESC-v to edit current line in your favorite $editor
    bindkey -M vicmd v edit-command-line
    # bindkey '^V' edit-command-line
    bindkey -r "^G" # was bound to list-expand I don't know where/why
    # bindkey '^G' push-line-or-edit

    bindkey '^P' up-history
    bindkey '^N' down-history

    # TODO doesn't work because it s overriden afterwards apparently
    . "${fzf}/share/fzf/completion.zsh"
    . "${fzf}/share/fzf/key-bindings.zsh"

  '';

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

  users.defaultUserShell = pkgs.zsh;

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
            # "webkitgtk-2.4.11"
              ];

    };

    # stdenv.userHook = ''
    #   '';
  };

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.tcp_allowed_congestion_control" = "reno cubic";
  };

  environment.etc."inputrc".source = ../../config/inputrc;

  # set it to true to help
  documentation.nixos.includeAllModules = false;


  # todo set it only if path exists
  # convert set back to list
  security.sudo = {
    enable = true;
    # wheelNeedsPassword = true;
  };

  system = {
    stateVersion = "19.03"; # why would I want to keep that ?
    copySystemConfiguration = true;
    # autoUpgrade = {
    #   channel= "https://nixos.org/channels/nixpkgs-unstable";
    #   enable = true;
    # };
  };

}
