{
  lib,
  pkgs,
  config,
  # , tetoLib
  ...
}:
let
  # key modifier
  mod = "Mod1";
  mad = "Mod4";

  term = "${pkgs.kitty}/bin/kitty";
  # we could go for xdg-terminal too
  # term = "${pkgs.rio}/bin/rio";
  # term = "${pkgs.wezterm}/bin/wezterm";

  rofi = pkgs.rofi-wayland;
  sharedConfig = pkgs.callPackage ./wm-config.nix { };

  myLib = pkgs.tetoLib;
in
# TODO load sway folder via haumea
{

  imports = [
    ./flameshot.nix
  ];

  # TODO it is done in sway.nix
  # replaced with  package-sets.wayland
  package-sets.waylandPackages = true;

  home.packages = [
    # waybar
    # eventually ironbar

    pkgs.sway-scratchpad
  ];

  ### swayr configuration {{{
  programs.swayr = {
    enable = true;
    systemd.enable = true;
  };

  #
  systemd.user.services.swayrd.Service = lib.mkIf config.programs.swayr.enable {
    Environment = [
      "PATH=${
        lib.makeBinPath [
          pkgs.fuzzel
          pkgs.wofi
        ]
      }"
    ];
  };
  # }}}

  # todo prepend sharedExtraConfig
  # xdg.configFile."sway/config" =

  wayland.windowManager.sway = {
    enable = true;
    # creates a sway-session target that is started on wayland start
    systemd.enable = true;

    # disabling swayfx until  those get merged
    # https://github.com/nix-community/home-manager/pull/4039
    # https://github.com/NixOS/nixpkgs/pull/237044

    # be careful as this can override default options
    # package = pkgs.swayfx;
    # package = pkgs.sway-unwrapped;

    checkConfig = false;

    config = {
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
      modes = sharedConfig.modes // {
        monitors =
          let
            move_to_output = dir: fr: us: {
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
          // move_to_output "down" "l" "l";
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
          #  {
          #   criteria = { app_id = "xdg-desktop-portal-gtk"; };
          #   command = "floating enable";
          # }

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
        # example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };
        #         Some outputs may have different names when disconnecting and reconnecting. To identify these, the name can be substituted for a string consisting of the make, model and serial which you can get from swaymsg -t get_outputs. Each value must be  sepa‐ rated by one space. For example:
        #     output "Some Company ABC123 0x00000000" pos 1920 0
        "HDMI-A-1" = {
          bg = "${../../wallpapers/toureiffel.jpg} fill";

        };

        #  "/home/teto/home/wallpapers/nebula.jpg fill"
        "*" = {
          adaptive_sync = "off";
          bg = "${../../wallpapers/nebula.jpg} fill";
        };

      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,fr";
          xkb_options = "ctrl:nocaps";
          xkb_numlock = "enabled"; # sadly bools wont work
          # repeat_delay 500
          # repeat_rate 5
          # to swap altwin:swap_lalt_lwin
        };
      };
      # terminal = term;
      bars = [ ];
      # menu =
      workspaceOutputAssign = [
        {
          workspace = "toto";
          output = "eDP1";
        }
      ];

      # we want to override the (pywal) config from i3
      colors = lib.mkForce { };

      # https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-sway
      # TODO
      # from https://www.reddit.com/r/swaywm/comments/uwdboi/how_to_make_chrome_popup_windows_floating/
      # mkBefore
      # ;config.xsession.windowManager.i3.config.keybindings
      keybindings = sharedConfig.sharedKeybindings // {
        "${mod}+grave" = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        "${mod}+p" = "exec ${pkgs.tessen}/bin/tessen --dmenu=rofi";

        "$GroupFr+$mod+ampersand" = "layout toggle all";
        "$GroupUs+$mod+1" = "layout toggle all";

        # start a terminal
        "${mod}+Return" = "exec --no-startup-id ${term}";
        "${mod}+Shift+Return" =
          ''exec --no-startup-id ${term} -d "$(${toString ../../bin/kitty-get-cwd.sh})"'';

        Menu = "exec ${rofi}/bin/rofi -modi 'drun' -show drun";
        "${mod}+Tab" = "exec ${rofi}/bin/rofi -modi 'drun' -show drun";
        # "${mod}+Ctrl+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'window' -show run\"";
        # TODO dwindow exclusively with WIN
        "${mad}+Tab" = "exec ${pkgs.swayr}/bin/swayr switch-window";
        "${mad}+p" = "exec ${lib.getExe pkgs.wofi-pass} ";
        "${mad}+a" = "exec \"${rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";
        # "${mad}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";

        # locker
        # "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";

        # TODO make it a command
        "${mod}+Ctrl+L" = "exec ${myLib.swaylockCmd} ";

        # TODO notify/throw popup when clipman fails
        # "${mod}+Ctrl+h" = ''exec ${pkgs.clipman}/bin/clipman pick -t rofi || ${sharedConfig.notify-send} 'Failed running clipman' '';
        # cliphist list | rofi -dmenu
        "${mod}+Ctrl+h" =
          ''exec ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu  -m -1 -p "Select item to copy" -lines 10 -width 35 | cliphist decode | wl-copy | ${sharedConfig.notify-send} 'Failed running cliphist' '';

        # kitty nvim -c ":Neorg workspace notes"
        # Notes is a custom command
        "${mod}+F1" =
          ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark neorg-notes --command 'kitty nvim +Notes'  '';
        "${mod}+F2" =
          ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark audio --command 'kitty ${config.programs.ncmpcpp.package}/bin/ncmpcpp' '';
        "${mod}+F3" =
          ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 60 --height 50 --mark gp_nvim --command "kitty nvim -cLlmChat" '';

        # TODO implement Travis/Pasting Voice recognized text
        # "${mod}+F4" =
        #   ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 60 --height 50 --mark gp_nvim --command "kitty nvim -c 'GpChat' " '';
        #

        "--release Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        # bindsym F12 exec sway-scratchpad --command "kitty -d /home/user/projects" --mark terminal

        # for_window [con_mark="SCRATCHPAD_terminal"] border pixel 1

        # use sway-easyfocus
        # "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        # "${mad}+w" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        # TODO bind
        # XF86Copy
      };

      startup =
        [
          # { command = "env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1"; }
          { command = "env RUST_BACKTRACE=1 swaycons"; }

        ]
        ++ lib.optional config.services.cliphist.enable (

          { command = "wl-paste --watch cliphist store"; }

        );
    };

    extraConfigEarly = sharedConfig.sharedExtraConfig;

    # output HDMI-A-1 bg ~/wallpaper.png stretch
    # TODO remove the config.shared stuff
    # create option for the for_window popups
    #       include ~/.config/i3/config.shared

    extraConfig = ''
      # timeout in ms
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
    # export MOZ_ENABLE_WAYLAND=1
    # TODO put it in the wrapper started by the .desktop file !
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
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';

    wrapperFeatures = {
      gtk = true;
    };
  };

  xdg.configFile."sway/config".text = lib.mkBefore "
	include ~/.config/i3/config.shared
   ";

  # env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1
  # https://git.sr.ht/~tsdh/swayr/tree/main/item/swayr/etc/swayrd.service
  # systemd.user.services.swayr = {
  #   Unit = {
  #    Type="simple";
  #    Environment="RUST_BACKTRACE=1";
  #    Description = "Swayr";
  #    Documentation="https://sr.ht/~tsdh/swayr/";
  # # PartOf=sway-session.target
  # # After=sway-session.target
  #     # Requires = [ "tray.target" ];
  #     # sway ?
  #     After = [ "tray.target" ];
  #     # PartOf = [ "graphical-session.target" ];
  #     # X-Restart-Triggers = mkIf (cfg.settings != { }) [ "${iniFile}" ];
  #   };

  #   Install = { WantedBy = [ "tray.target" ]; };

  #   Service = {
  #     # Environment = "PATH=${config.home.profileDirectory}/bin:${pkgs.grim}/bin";
  #     ExecStart = "${pkgs.swayr}/bin/swayr";
  #     Restart="on-failure";
  #     # Restart = "on-abort";

  #     # Sandboxing.
  #     # LockPersonality = true;
  #     # MemoryDenyWriteExecute = true;
  #     # NoNewPrivileges = true;
  #     # PrivateUsers = true;
  #     # RestrictNamespaces = true;
  #     # SystemCallArchitectures = "native";
  #     # SystemCallFilter = "@system-service";
  #   };
  # };

}
