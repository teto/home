{ config, lib, pkgs, ... }:
let
  # key modifier
  # mad = "Mod4";
  mod = "Mod1";

  term = "${pkgs.kitty}/bin/kitty";

  sharedConfig = pkgs.callPackage ./wm-config.nix {};

in
{
  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
  };

  # todo prepend sharedExtraConfig
  # xdg.configFile."sway/config" = 

  wayland.windowManager.sway = {
    config = (builtins.removeAttrs config.xsession.windowManager.i3.config [ "startup" "bars" ])
      // {
      input = {
        "type:keyboard" = {
          xkb_layout = "us,fr";
          xkb_options = "ctrl:nocaps";
          # to swap altwin:swap_lalt_lwin
        };
      };
      terminal = term;
      bars = [
        {
          position = "top";
          workspaceButtons = true;
          workspaceNumbers = false;
          # id="0";
          # command="${pkgs.waybar}/bin/waybar";
          command = "${pkgs.sway}/bin/swaybar";
          statusCommand = "${pkgs.i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
          # extraConfig = ''
          #   icon_theme Adwaita
          # '';
        }
      ];

      # we want to override the (pywal) config from i3
      colors = lib.mkForce { };

      # Notification Daemon
      # Toggle control center
      # keybindings = {
      #   # "$mod+Shift+n" = " exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
      #   # clipman can be used too
      #   # clipman pick -t wofi
      #   # "${mod}+Ctrl+h" = lib.mkForce ''exec "${pkgs.clipman}/bin/clipman pick -t wofi'';
      #   # "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ui 2 && pamixer --get-volume > $SWAYSOCK.wob";
      #   # # "exec --no-startup-id pactl set-sink-volume 0 +5%;exec ${notify-send} --icon=speaker_no_sound -u low -t 1000 'Audio Raised volume'";
      #   # "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ud 2 && pamixer --get-volume > $SWAYSOCK.wob";
      #   # "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
      # };
    # https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-sway
    # TODO
    # from https://www.reddit.com/r/swaywm/comments/uwdboi/how_to_make_chrome_popup_windows_floating/
	# mkBefore
      keybindings = lib.recursiveUpdate config.xsession.windowManager.i3.config.keybindings {
        "$GroupFr+$mod+ampersand" = "layout toggle all";
        "$GroupUs+$mod+1" = "layout toggle all";
        "${mod}+Ctrl+L" = "exec ${pkgs.swaylock}/bin/swaylock";
      };



      # focus.wrapping = "yes";
      startup = [
        # { command = "wl-paste -t text --watch clipman store"; }
        # { command = ''wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''; }
        # { command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob"; }
        # { command = "swaync"; }
      ];
    };



    # statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";

	extraConfigEarly = sharedConfig.sharedExtraConfig;

    extraConfig = builtins.readFile ../../config/i3/config.shared + ''
      bindsym button2 kill
      smart_gaps yes

      # Generated windows.
      for_window [title="(?:Open|Save) (?:File|Folder|As)"] floating enable;
      for_window [title="(?:Open|Save) (?:File|Folder|As)"] resize set 800 600
      for_window [window_role="pop-up"] floating enable
      for_window [window_role="bubble"] floating enable
      for_window [window_role="task_dialog"] floating enable
      for_window [window_role="Preferences"] floating enable
      for_window [window_type="dialog"] floating enable
      for_window [window_type="menu"] floating enable
      '';

    # extraConfig =  ''
    #   default_floating_border pixel 2
    # '';



    extraOptions = [
      "--verbose"
      "--debug"
    ];
    # eventually start foot --server
    # TODO we should wrap sway with that ?
    # export GBM_BACKENDS_PATH=/etc/gbm
    extraSessionCommands = ''
    # according to https://www.reddit.com/r/swaywm/comments/11d89w2/some_workarounds_to_use_sway_with_nvidia/
    export XWAYLAND_NO_GLAMOR=1

      # needs qt5.qtwayland in systemPackages
    export QT_QPA_PLATFORM=wayland
    # works without GBM_BACKEND
    # export GBM_BACKEND=nvidia-drm
    export SDL_VIDEODRIVER=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';

    wrapperFeatures = { gtk = true; };
 };

  xdg.configFile."sway/config".text = lib.mkBefore "
	include ${../../config/i3/config.shared}
   ";

  home.packages = with pkgs; [
    clipman # clipboard manager, works with wofi, y a ptet un module
    foot # terminal
    # use it with $ grim -g "$(slurp)"
    grim # replace scrot/flameshot
    kanshi # autorandr-like
    wofi # rofi-like
    slurp # capture tool
    wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    # waybar # just for testing
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    wob # to display a progressbar
    swaynotificationcenter # top cool broken
    swaynag-battery # https://github.com/NixOS/nixpkgs/pull/175905
  ];

  services.mako = {
    # disabled in favor of swaync
    enable = false;
    defaultTimeout = 4000;
    ignoreTimeout = false;
  };

  services.kanshi = {
    enable = true;
  };
}
