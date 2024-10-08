{
  config,
  lib,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    i3lock-fancy
    mupdf.bin # evince does better too
    rofi
    xautolock
    xorg.xkill
    xorg.xwininfo # for stylish
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # TODO enable in host-specific configuration
    # autorun = true;

    displayManager = {
      # enable startx if you want to bypass display managers
      startx.enable = true;
      # TODO move to host config
      # autoLogin = {
      #   enable = false;
      #   user = "teto";
      # };
      defaultSession = "none+i3";
      lightdm = {
        enable = false;
        greeter.enable = false;
      };
      # https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/11
      # session =
      #   let fakeSession = { manage = "window";
      #                       name = "fake";
      #                       start = "";
      #                     };
      #   in [ fakeSession ];
      # defaultSession = null;
      gdm = {
        # enable = false;
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
    layout = "us,fr"; # you can switch from cli with xkb-switch
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

    # to autostart i3
    # https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/7
    # desktopManager.defaultSession = "gnome"
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
