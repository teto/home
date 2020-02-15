{ config, lib,  pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # haskellPackages.greenclip # todo get from haskell
    mupdf.bin # evince does better too
    rofi
    xautolock
    i3lock-fancy
    gksu # to run graphical apps as root
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    displayManager = {
      lightdm.autoLogin = {
        enable = false;
        user = "teto";
      };
      # job.logXsession = true; # writes into ~/.xsessions-errors
      # enableCtrlAltBackspace = false;
      # for the smaller setup setup the favorite mode to 1920 x 1080
       # screenSection = '' '';
    };

    # required to make localectl work
    # see https://github.com/NixOS/nixpkgs/issues/19629
    exportConfiguration = true;

    # allow for more layout
    layout = "us,fr";  # you can switch from cli with xkb-switch
    # TODO swap esc/shift
    xkbOptions = "eurosign:e";
    # xkbOptions = "eurosign:e, caps:swapescape";
    # xbkDir

    libinput = {
      enable = true;
      # twoFingerScroll = true;
      disableWhileTyping = true;
      # Natural scrolling is about moving in the same direction as the page
      # I hate that so set to no
      naturalScrolling = false;
      # accelSpeed = "1.55";
    };

  };
  # services.xserver.desktopManager.default = "none";
  # services.xserver.desktopManager.xterm.enable = true;
  # # services.xserver.desktopManager.x
  # # services.xserver.windowManager.default = "none";
  # services.xserver.windowManager.i3.enable = true;
  # # xserver.displayManager.auto.enable = "teto";
  # # boot.extraModulePackages
  # services.xserver = {
  #   enable = true;
  #   autorun = true;
  #   # exportConfiguration = true;
  #   desktopManager.default = "none";
  #   desktopManager.xterm.enable = true;
  #   enableCtrlAltBackspace = true;

  #   displayManager.lightdm = {
  #     autoLogin = {
  #       enable = false;
  #       user = "teto";
  #     };
  #     # background = ;
  #   };
  #   # displayManager.slim = {
  #   #     autoLogin = true;
  #   #     defaultUser = "teto";
  #   # };
  #   # set the correct primary monitor
  #   # xrandrHeads = [
  #   #   {
  #   #     primary = true;
  #   #     # monitorConfig = ''
  #   #     #   '';
  #   #     output = "DP-2";
  #   #   }
  #   # ];

  #   videoDrivers = [ "nvidia" ];
  # };

}
