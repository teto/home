# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
  boot.loader.grub.device = "/dev/sda";

  # see https://github.com/NixOS/nixpkgs/issues/15293
  # boot.kernelPackages = pkgs.linuxPackages_latest;


  networking.hostName = "jedha"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "fr";
     defaultLocale = "fr_FR.UTF-8";
     inputMethod = {
       enabled = "fcitx";
       fcitx.engines = with pkgs.fcitx-engines; [
         mozc
       # hangul m17n
     ];
     };
   };



  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    astroid
     automake
     autoconf
     autojump
     cmake
     dex
	 dunst
	 fzf
     # lgogdownloader
     libtool
     libreoffice
     libnotify # use via {pkgs.libnotify}/bin/notify-send
	 gawk
     git
	 # git-extras # does not find it (yet)
     gnum4
	 mpv
	 ncmpcpp
     networkmanager
     networkmanagerapplet
     offlineimap
     neovim
     pkgconfig
     # pypi2nix # to convert
	 python3
	 pythonPackages.neovim
	 pythonPackages.pandas
	 pythonPackages.keyring
	 # pythonPackages.matplotlib
     # qutebrowser
	 neovim-remote
	 qtpass
     ranger
     rofi
     ripgrep
     silver-searcher
     stow
     termite
	 tmux
	 unzip
     vifm
	 # vlc
     xorg.xmodmap
     wget
     weechat
	 xclip
     xdg-user-dirs
     # xdg-utils
     zsh
  ];

  environment.variables.EDITOR="nvim";


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
	enable = true;
	drivers = [ pkgs.gutenprint ];
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.displayManager = {
	auto = {
		enable = false;
		user = "teto";
	};
  };
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.xterm.enable = false;
  # extraSessionCommands / configFile
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  # for nix-shell
  programs.bash.enableCompletion = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.extraUsers.teto = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = ["wheel" "networkmanager"];
	 shell = pkgs.zsh;
  };
  nixpkgs.config = {
	allowUnfree = true;
    permittedInsecurePackages = [
          "webkitgtk-2.4.11"
            ];
  };

  # pkgs.lib.mkBefore
  nix.nixPath =  [
    "nixpkgs=/home/teto/nixpkgs"
    "nixos-config=/home/teto/dotfiles/nixpkgs/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ] ;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
