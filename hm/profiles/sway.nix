{ config, lib, pkgs, ... }:
let
  # key modifier
  mod = "Mod1";
  mad = "Mod4";

  term = "${pkgs.kitty}/bin/kitty";

  sharedConfig = pkgs.callPackage ./wm-config.nix {};

in
{
  home.packages = with pkgs; [
    # clipman # clipboard manager, works with wofi, y a ptet un module
    foot # terminal
    # use it with $ grim -g "$(slurp)"
    grim # replace scrot/flameshot
    kanshi # autorandr-like
    kickoff # transparent launcher for wlr-root
    fnott # notification tool
    wofi # rofi-like
    slurp # capture tool
    wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    wob # to display a progressbar
    swaybg # to set wallpaper
    swayimg # imageviewer
    swaynotificationcenter # top cool broken
    # could use fnott as well !
    swaynag-battery # https://github.com/NixOS/nixpkgs/pull/175905
    sway-launcher-desktop # fzf-based launcher
    sov  # sway overview https://github.com/milgra/sov
    wlr-randr # like xrandr
    nwg-bar  # locks nothing
    nwg-drawer # launcher
    nwg-menu
    wlogout
    swaylock
    sway-contrib.grimshot # contains "grimshot" for instance
    shotman # -c region 
    waybar
    wlprop # like xprop, determines window parameters
    polybar
    # swappy # e https://github.com/jtheoof/swappy
    # https://github.com/artemsen/swaykbdd # per window keyboard layout
    # wev # event viewer https://git.sr.ht/~sircmpwn/wev/
  ];

  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
  };

  services.clipman = {
    enable = true;
    # see doc for systemdTarget
    # systemdTarget = 
  };
  # todo prepend sharedExtraConfig
  # xdg.configFile."sway/config" = 

  wayland.windowManager.sway = {
   enable = true;
   systemd.enable = true;
     # defaultSwayPackage = pkgs.sway.override {
    # extraSessionCommands = cfg.extraSessionCommands;
    # extraOptions = cfg.extraOptions;
    # withBaseWrapper = cfg.wrapperFeatures.base;
    # withGtkWrapper = cfg.wrapperFeatures.gtk;
  # };


   # disabling swayfx until  those get merged 
   # https://github.com/nix-community/home-manager/pull/4039
   # https://github.com/NixOS/nixpkgs/pull/237044

   package = pkgs.swayfx;
   # package = pkgs.sway-unwrapped;

   config = 
   # (builtins.removeAttrs config.xsession.windowManager.i3.config [ "startup" "bars" ])
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
        "$GroupFr+$mod+ampersand" = "layout toggle all";
        "$GroupUs+$mod+1" = "layout toggle all";
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

    # "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
    "${mod}+Ctrl+h" = ''exec "${pkgs.clipman}/bin/clipman pick -t rofi'';
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


  services.mako = {
    # disabled in favor of swaync
    enable = false;
    defaultTimeout = 4000;
    ignoreTimeout = false;
  };

  services.kanshi = {
    enable = true;
  };

  programs.waybar = let 

   # TODO make sure it has jq in PATH
   githubUpdater = pkgs.writeShellApplication 
    { name = "github-updater";
      runtimeInputs = [ pkgs.coreutils pkgs.curl pkgs.jq ];
      text = (builtins.readFile ../modules/waybar/github.sh);
      checkPhase = ":";
    };


  in {
   enable = true;
   systemd.enable = true;
   settings = {
     mainBar = {
       layer = "top";
       position = "top";
       height = 30;
       # output = [
         # "eDP-1"
         # "HDMI-A-1"
       # ];
       # "wlr/taskbar" 
       modules-left = [
        "sway/workspaces"
        "sway/mode"
       ];
       modules-center = [
        "sway/window" 
       # "custom/hello-from-waybar"
      ];
       modules-right = [ 
        "mpd"

        # "custom/mymodule#with-css-id"
        # "temperature"
        "clock"
        "idle_inhibitor"
        "wireplumber"
        "custom/notification"
        "custom/github"
        "custom/notmuch"
        "tray"
       ];
    tray= {
        # "icon-size": 21,
        "spacing"= 10;
    };
    mpd = {
        "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ ";
        "format-disconnected" = "Disconnected ";
        "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
        "unknown-tag" = "N/A";
        "interval" = 2;
        "consume-icons" = {
            "on" = " ";
        };
        "random-icons" = {
            "off" = "<span color=\"#f53c3c\"></span> ";
            "on" = " ";
        };
        "repeat-icons" = {
            "on" = " ";
        };
        "single-icons" = {
            "on" = "1 ";
        };
        "state-icons" = {
            "paused" = "";
            "playing" = "";
        };
        "tooltip-format" = "MPD (connected)";
        "tooltip-format-disconnected" = "MPD (disconnected)";
    };

    idle_inhibitor = {


     "format-icons" = {
       "activated" = "activated";
       "deactivated"= "inhibit";
     };
    };
    wireplumber= {
     "format"= "{volume}% {icon}";
     "format-muted"= "";
     on-click = "helvum";
     on_click = "kitty sh -c alot -l/tmp/alot.log";

     "format-icons"= ["" "" ""];
    };
    clock = {
        # "timezone": "America/New_York",
        # TODO look how to display timezone
        "timezones" = [  "Europe/Paris"  "Asia/Tokyo" ];
        "tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        "format-alt"= "{:%Y-%m-%d}";
     };
    cpu= {
        format= "{usage}% ";
        tooltip= false;
    };
       "sway/workspaces" = {
        # {name}:
         format= "{name}";
         disable-scroll = false;
         all-outputs = false;
         # disable-scroll-wraparound = true;
         # "disable-markup" : false,
         # format-icons = {
         #    "1" = "";
         #    "2" = "";
         #    "3" = "";
         # };
       };
    temperature= {
        # "thermal-zone": 2,
        # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        critical-threshold= 80;
        # // "format-critical": "{temperatureC}°C {icon}",
        format = "{temperatureC}°C {icon}";
        format-icons =  [""  ""  ""];
    };

       "custom/notification" = {
         tooltip = false;
         format = "{icon}";
         "format-icons" = {
           notification = "<span foreground='red'><sup>notifs</sup></span>";
           none = "No notifications";
           inhibited-notification = "inhibtited<span foreground='red'><sup>toto</sup></span>";
           inhibited-none = "0";
           # Do Not Disturb
           dnd-notification = "dnd <span foreground='red'><sup>dnd</sup></span>";
           dnd-none = "no dnd";
           dnd-inhibited-notification = "dnd<span foreground='red'><sup>dnd</sup></span>";
           dnd-inhibited-none = "none";
         };
         return-type = "json";
         # exec-if = "which swaync-client";
         exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
         on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
         on-click-right = "swaync-client -d -sw";
         escape = true;
       };
       "custom/github"= {
          "format"= "{} ";
          "return-type"= "json";
          # The interval (in seconds) in which the information gets polled
          "restart_interval"= 60;
          # "exec"= "$HOME/.config/waybar/github.sh";
          exec = lib.getExe githubUpdater;
          on-click = "${pkgs.xdg_utils}/bin/xdg-open https://github.com/notifications";
      };

     network = {
         # // "interface": "wlp2*", // (Optional) To force the use of this interface
         format-wifi = "{essid} ({signalStrength}%) ";
         format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
         format-linked = "{ifname} (No IP) ";
         format-disconnected = "Disconnected ⚠";
         format-alt = "{ifname}: {ipaddr}/{cidr}";
     };

      
      "custom/notmuch" = let 
         notmuchChecker = pkgs.writeShellApplication 
         { name = "waybar-notmuch-module";
           runtimeInputs = [ pkgs.notmuch pkgs.jq ];
           text = builtins.readFile ../modules/waybar/notmuch.sh;
           checkPhase = ":";
         };
      in {
         format = "  : {}";
         max-length = 40;
         return-type = "json";
         # TODO run regularly
         interval = 60;
         on_click = "kitty sh -c alot -l/tmp/alot.log";
         # TODO rerun mbsync + notmuch etc
         # TODO read
         # exec-on-event = false;
         on-click-right = "systemctl start mbsync.service";
         exec = lib.getExe notmuchChecker;

         # exec = pkgs.writeShellScript "hello-from-waybar" ''
         #   echo "from within waybar"
         # '';
       };
     };
    };
  };
}
