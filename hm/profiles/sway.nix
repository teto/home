{ config, lib, pkgs,  ... }:
let

  term = "${pkgs.kitty}/bin/kitty";
in
{
  # https://github.com/rycee/home-manager/pull/829

  wayland.windowManager.sway = {
    # enable = true;
    systemdIntegration = true;

    # eventually start foot --server
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
    wrapperFeatures = { gtk = true; };


    # config = removeAttrs  config.xsession.windowManager.i3.config ["startup"];
    config = {
    #   menu =
      terminal = term;

      keybindings = let
        mod="Mod1";
      in {
        # clipman can be used too
        # clipman pick -t wofi
        "${mod}+Ctrl+h" = lib.mkForce ''exec "${pkgs.clipman}/bin/clipman pick -t wofi'';
      };

      focus.forceWrapping = lib.mkForce true;
      startup = [
        { command =  "wl-paste -t text --watch clipman store"; }
        { command = ''exec wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''; }
      ];
    };

    #       focus_wrapping force

    extraConfig = ''
      smart_gaps yes
    '';
  };

  home.packages = with pkgs; [
    # grimshot # simplifies usage of grim ?
    clipman  # clipboard manager, works with wofi
    foot  # terminal
    grim  # replace scrot
    kanshi  # autorandr-like
    wofi  # rofi-like
    slurp  # capture tool
    # wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
  ];

  programs.mako = {
    enable = true;
    defaultTimeout = 4000;
    ignoreTimeout = false;
  };

  services.kanshi = {
    enable = true;
    # profiles = 
    # extraConfig = 
  };
}
