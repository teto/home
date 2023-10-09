{ config, lib, pkgs, ... }:
let
  # key modifier
  mod = "Mod1";
  mad = "Mod4";

  term = "${pkgs.kitty}/bin/kitty";

  sharedConfig = pkgs.callPackage ./wm-config.nix {};

in
{

  imports = [
    ./wayland.nix
  ];

  home.packages = with pkgs; [

   clipman # clipboard manager, works with wofi, abandoned
   cliphist
    # TODO test https://github.com/sentriz/cliphist
    foot # terminal
    # use it with $ grim -g "$(slurp)"
    grim # replace scrot/flameshot
    kanshi # autorandr-like
    kickoff # transparent launcher for wlr-root
    wofi # rofi-like
    slurp # capture tool
    # lavalauncher # TODO a tester
    wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    swaybg # to set wallpaper
    swayimg # imageviewer
    swaynotificationcenter # top cool
    swaynag-battery # https://github.com/NixOS/nixpkgs/pull/175905
    sway-launcher-desktop # fzf-based launcher
    # sway overview, draws layouts for each workspace: dope https://github.com/milgra/sov
    sov  
    wlr-randr # like xrandr
    nwg-bar  # locks nothing
    nwg-drawer # launcher
    nwg-menu
    nwg-dock # a nice dock 
    wlogout
    swaylock
    sway-contrib.grimshot # contains "grimshot" for instance
    shotman # -c region 
    tessen # handle passwords
    waybar
    # eventually ironbar
    wlprop # like xprop, determines window parameters
    # swappy # e https://github.com/jtheoof/swappy
    # https://github.com/artemsen/swaykbdd # per window keyboard layout
    # wev # event viewer https://git.sr.ht/~sircmpwn/wev/
    wl-gammactl # to control gamma
  ];

  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
  };

  # services.clipman.enable = true;

  services.cliphist.enable = true;

  # todo prepend sharedExtraConfig
  # xdg.configFile."sway/config" = 

  wayland.windowManager.sway = {
   enable = true;
   # creates a sway-session target that is started on wayland start
   systemd.enable = true;

   # disabling swayfx until  those get merged 
   # https://github.com/nix-community/home-manager/pull/4039
   # https://github.com/NixOS/nixpkgs/pull/237044

  # package = pkgs.swayfx;
   # package = pkgs.sway-unwrapped;

   config = 
      {
        terminal = term;
        workspaceAutoBackAndForth = true;

        focus = {
          followMouse = false;
          wrapping = "yes";
        };

        fonts = {
          # Source Code Pro
          names = [ "Inconsolata Normal" ];
          size = 12.0;
        };
      modes = {
        monitors =
          let
            move_to_output = dir: fr: us:
              {
                "$GroupFr+$mod+${fr}" = "move workspace to output ${dir}";
                "$GroupUs+$mod+${us}" = "move workspace to output ${dir}";
              };
          in
          {
            "Escape" = "mode default";
            "Return" = "mode default";
          }
          // move_to_output "left" "Left" "Left"
          // move_to_output "left" "j" "j"
          // move_to_output "right" "Right" "Right"
          # // move_to_output "right" "m" "semicolumn"
          // move_to_output "top" "Up" "Up"
          // move_to_output "top" "k" "k"
          // move_to_output "down" "down" "down"
          // move_to_output "down" "l" "l"
        ;
        # mouse= {
        # bindsym $mod+Left exec	$(xdotool mousemove_relative --sync -- -15 0)
        # bindsym $mod+Right exec $(xdotool mousemove_relative --sync -- 15 0)
        # bindsym $mod+Down exec  $(xdotool mousemove_relative --sync -- 0 15)
        # bindsym $mod+Up   exec  $(xdotool mousemove_relative --sync -- 0 -15)
        # }

        # # Enter papis mode
        # papis = {
        #   # open documents
        #   "$mod+o" = "exec python3 -m papis.main --pick-lib --set picktool dmenu open";
        #   # edit documents
        #   "$mod+e" = "exec python3 -m papis.main --pick-lib --set picktool dmenu --set editor gvim edit";
        #   # open document's url
        #    "$mod+b" = "exec python3 -m papis.main --pick-lib --set picktool dmenu browse";
        # #   bindsym Ctrl+c mode "default"
        #   "Escape" = ''mode "default"'';
        # };

        # rofi-scripts = {
        #   # open documents
        #   "$mod+l" = "sh j";
        #   "Return" = ''mode "default"'';
        #   "Escape" = ''mode "default"'';
        # };

        # i3resurrect parts
        saveworkspace = {
          "1" = "exec $i3_resurrect save -w 1";
          "2" = "exec $i3_resurrect save -w 2";
          "3" = "exec $i3_resurrect save -w 3";
          "4" = "exec $i3_resurrect save -w 4";
          "5" = "exec $i3_resurrect save -w 5";
          "6" = "exec $i3_resurrect save -w 6";
          "7" = "exec $i3_resurrect save -w 7";
          "8" = "exec $i3_resurrect save -w 8";
          "9" = "exec $i3_resurrect save -w 9";
          "0" = "exec $i3_resurrect save -w 0";

          # Back to normal: Enter, Escape, or s
          Return = ''mode "default"'';
          Escape = ''mode "default"'';
        };
      };

       window = {
         hideEdgeBorders = "smart";

        commands = [
        {
         criteria = { app_id = "xdg-desktop-portal-gtk"; };
         command = "floating enable";
       }
       # for_window [title="(?:Open|Save) (?:File|Folder|As)"] floating enable;
# for_window [title="(?:Open|Save) (?:File|Folder|As)"] resize set 800 600
# for_window [window_role="pop-up"] floating enable
# for_window [window_role="bubble"] floating enable
# for_window [window_role="task_dialog"] floating enable
# for_window [window_role="Preferences"] floating enable
# for_window [window_type="dialog"] floating enable
# for_window [window_type="menu"] floating enable
      ];
     };
       output = {
        # todo put a better path
        # example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };

         "*" = {  bg = "/home/teto/home/wallpapers/nebula.jpg fill"; };
        
       };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,fr";
          xkb_options = "ctrl:nocaps";
          xkb_numlock =  "enabled"; # sadly bools wont work
          # repeat_delay 500
          # repeat_rate 5
          # to swap altwin:swap_lalt_lwin
        };
      };
      # terminal = term;
      bars = [
      ];
      # menu = 
      workspaceOutputAssign = [
       { 
        workspace="toto";
        output = "eDP1";
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
    # ;config.xsession.windowManager.i3.config.keybindings
    keybindings = sharedConfig.sharedKeybindings // {
         "${mod}+p" = "exec ${pkgs.tessen}/bin/tessen --dmenu=rofi";

        "$GroupFr+$mod+ampersand" = "layout toggle all";
        "$GroupUs+$mod+1" = "layout toggle all";
        # TODO https://crates.io/crates/sway-scratchpad
        # "F12" = "exec ~/.cargo/bin/sway";
        # "$mod+F1" = [instance="pad_(?!ncmpcpp)"] move scratchpad; [instance="pad_ncmpcpp"] scratchpad show

        # "${mod}+Ctrl+L" = "exec ${pkgs.swaylock}/bin/swaylock";
    # start a terminal
    "${mod}+Return" = "exec --no-startup-id ${term}";
    "${mod}+Shift+Return" = ''exec --no-startup-id ${term} -d "$(${toString ../../bin/kitty-get-cwd.sh})"'';

    "${mod}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'drun,window,ssh' -show drun\"";
    "${mod}+Ctrl+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'window' -show run\"";
    # TODO dwindow exclusively with WIN
    "${mad}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";
    "${mad}+a" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";
    # "${mad}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";

    # locker
    # "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    "${mod}+Ctrl+L" = "exec ${pkgs.swaylock}/bin/swaylock";

    # TODO notify/throw popup when clipman fails 
    # "${mod}+Ctrl+h" = ''exec ${pkgs.clipman}/bin/clipman pick -t rofi || ${sharedConfig.notify-send} 'Failed running clipman' '';
    # cliphist list | rofi -dmenu
    "${mod}+Ctrl+h" = ''exec ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu || ${sharedConfig.notify-send} 'Failed running cliphist' '';

    # "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
    # "${mad}+w" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
    # TODO bind
     # XF86Copy
      };

      startup = [
        # { command = "wl-paste -t text --watch clipman store"; }
        # { command = ''wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''; }
       { command =  "${term} ncmpcpp"; }
      ];
    };


	extraConfigEarly = sharedConfig.sharedExtraConfig;

    # output HDMI-A-1 bg ~/wallpaper.png stretch
    # TODO remove the config.shared stuff
    # create option for the for_window popups
    extraConfig = builtins.readFile ../../config/i3/config.shared + ''

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      bindsym button2 kill

      # Generated windows.
      for_window [title="(?:Open|Save) (?:File|Folder|As)"] floating enable;
      for_window [title="(?:Open|Save) (?:File|Folder|As)"] resize set 800 600
      for_window [window_role="pop-up"] floating enable
      for_window [window_role="bubble"] floating enable
      for_window [window_role="task_dialog"] floating enable
      for_window [window_role="Preferences"] floating enable
      for_window [window_type="dialog"] floating enable
      for_window [window_type="menu"] floating enable


      # timeout in ms
      seat * hide_cursor 8000
      include ~/.config/sway/manual.config
      '';
      # include ~/.config/sway/swayfx.txt


    extraOptions = [
      "--verbose"
      "--debug"
    ];
    # eventually start foot --server
    # TODO we should wrap sway with that ?
    # some of these advised by https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
    extraSessionCommands = ''
    # according to https://www.reddit.com/r/swaywm/comments/11d89w2/some_workarounds_to_use_sway_with_nvidia/
    export XWAYLAND_NO_GLAMOR=1

     # useful for electron based apps: slack / vscode 
    export NIXOS_OZONE_WL=1

      # needs qt5.qtwayland in systemPackages
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export SDL_VIDEODRIVER=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';

    wrapperFeatures = { gtk = true; };
 };

  xdg.configFile."sway/config".text = lib.mkBefore "
	include ${../../config/i3/config.shared}
   ";


  # services.mako = {
  #   # disabled in favor of swaync
  #   enable = false;
  #   defaultTimeout = 4000;
  #   ignoreTimeout = false;
  # };

  services.kanshi = {
    enable = true;
  };

}
