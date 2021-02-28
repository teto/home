{ config, lib,  pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    mupdf.bin # evince does better too
    rofi
    xautolock
    i3lock-fancy
    gksu # to run graphical apps as root
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun =true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "teto";
      };
      defaultSession = "none+i3";
      # https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/11
      # session =
      #   let fakeSession = { manage = "window";
      #                       name = "fake";
      #                       start = "";
      #                     };
      #   in [ fakeSession ];
      # defaultSession = null;
      gdm = {
        wayland = true;
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
    # consoleUseXkbConfig
    xkbOptions = "eurosign:e, swapcaps:ctrl";

    libinput = {
      enable = true;
      # twoFingerScroll = true;
      touchpad.disableWhileTyping = true;
      # Natural scrolling is about moving in the same direction as the page
      # I hate that so set to no
      touchpad.naturalScrolling = false;
      # accelSpeed = "1.55";
    };

    displayManager = {
      lightdm = {
        enable = true;
        greeter.enable = false;
      };
    };
    windowManager.i3.enable = true;

    # to autostart i3
    # https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/7
    desktopManager.session = [
      {
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }
    ];
  };

}
