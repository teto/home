{ config, lib, pkgs,  ... }:
let

  term = "${pkgs.kitty}/bin/kitty";
in
{
  # https://github.com/rycee/home-manager/pull/829

  wayland.windowManager.sway = {
    enable = true;
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
        # "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ui 2 && pamixer --get-volume > $SWAYSOCK.wob";
        # # "exec --no-startup-id pactl set-sink-volume 0 +5%;exec ${notify-send} --icon=speaker_no_sound -u low -t 1000 'Audio Raised volume'";
        # "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ud 2 && pamixer --get-volume > $SWAYSOCK.wob";
        # "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
      };


      focus.forceWrapping = lib.mkForce true;
      startup = [
        { command =  "wl-paste -t text --watch clipman store"; }
        { command = ''wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''; }
        { command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob"; }
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
    waybar  # just for testing
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    wob # to display a progressbar
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
