# to list cards
# ls -l /sys/class/drm/renderD*/device/driver
# WLR_DRM_DEVICES
{
  lib,
  pkgs,
  config,
  # dotfilesPath,
  ...
}:
let

  inherit (lib.sway)
    mod
    mad
    move_focused_wnd
    bind_ws
    wsAzertyBindings
    wsQwertyBindings
    ;

  rawTerm = "${pkgs.kitty}/bin/kitty";

  # Start terminals in a directory associated with the focused Sway workspace.
  # Add more workspace-number/directory pairs to the case statement as needed.
  term = "${pkgs.kitty-workspace}/bin/kitty-for-workspace";

  rofi = pkgs.rofi-teto;
  sharedConfig = pkgs.callPackage ./wm-config.nix { inherit config; };
in
{

  wayland.windowManager.sway = {
    # enable = true;

    # creates a sway-session target that is started on wayland start
    systemd = {
      enable = true;

      # just trying what's advised at https://github.com/NixOS/nixpkgs/issues/177900#issuecomment-3167947983
      extraCommands = [

      ];

      # turns out enabling way-displays kills of all that
      # variables = [
      #     "DISPLAY"
      #     "WAYLAND_DISPLAY"
      #     "SWAYSOCK"
      #     "XDG_CURRENT_DESKTOP"
      #     "XDG_SESSION_TYPE"
      #     "NIXOS_OZONE_WL"
      #   ];
    };

    config = {
      terminal = term;
      workspaceAutoBackAndForth = true;

      focus = {
        followMouse = false;
        wrapping = "yes";
      };

      fonts = {
        # Source Code Pro
        # TODO use the japanese font
        names = [ "Inconsolata Normal" ];
        size = 12.0;
      };
      modes = {
        monitors =
          let
            move_to_output = dir: fr: us: {
              "$GroupFr+$mod+${fr}" = "move workspace to output ${dir}";
              "$GroupUs+$mod+${us}" = "move workspace to output ${dir}";
            };
          in
          {
            Escape = "mode default";
            Return = "mode default";
          }
          // move_to_output "left" "Left" "Left"
          // move_to_output "left" "j" "j"
          // move_to_output "right" "Right" "Right"
          # // move_to_output "right" "m" "semicolumn"
          // move_to_output "top" "Up" "Up"
          // move_to_output "top" "k" "k"
          // move_to_output "down" "down" "down"
          // move_to_output "down" "l" "l";

        # resize window (you can also use the mouse for that) {{{
        resize = {
          Escape = "mode default";
          Return = "mode default";

          # Pressing right will grow the window’s width.
          # Pressing up will shrink the window’s height.
          # Pressing down will grow the window’s height.
          j = " resize grow down 10 px or 10 ppt";
          "Shift+j" = "resize shrink down 10 px or 10 ppt";

          k = " resize grow up  10 px or 10 ppt";
          "Shift+k" = "resize shrink up 10 px or 10 ppt";

          l = "resize grow right 10 px or 10 ppt";
          "Shift+l" = "resize shrink right 10 px or 10 ppt";

          h = "resize grow left 10 px or 10 ppt";
          "Shift+h" = "resize shrink left 10 px or 10 ppt";

          # semicolumn is not recognized by sway
          # bindsym $GroupUs+semicolumn resize grow right 10 px or 10 ppt
          # bindsym $GroupUs+Shift+semicolumn resize shrink right 10 px or 10 ppt

          # same bindings, but for the arrow keys
          #bindsym Right resize shrink width 10 px or 10 ppt
          #bindsym Up resize grow height 10 px or 10 ppt
          #bindsym Down resize shrink height 10 px or 10 ppt
          #bindsym Left resize grow width 10 px or 10 ppt
          Left = " resize grow left 10 px or 10 ppt";
          "Shift+Left" = "resize shrink left 10 px or 10 ppt";

          Up = " resize shrink up  10 px or 10 ppts";
          "Shift+Up" = "resize grow up 10 px or 10 ppt";

          Down = "resize grow down 10 px or 10 ppt";
          "Shift+Down" = "resize shrink down 10 px or 10 ppt";

          Right = "resize grow right 10 px or 10 ppt";
          "Shift+Right" = "resize shrink right 10 px or 10 ppt";
        };
      }
      // {
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
            # always focus pinentry, (add to module)
            criteria = {
              app_id = "^pinentry-gnome3$";
            };
            command = "floating enable, move position center, focus";
          }
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
      bars = [ ];
      # menu =

      # we want to override the (pywal) config from i3
      colors = lib.mkForce { };

      # https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-sway
      # TODO
      # from https://www.reddit.com/r/swaywm/comments/uwdboi/how_to_make_chrome_popup_windows_floating/
      # mkBefore
      # ;config.xsession.windowManager.i3.config.keybindings
      keybindings =
        sharedConfig.sharedKeybindings
        // (lib.concatMapAttrs (bind_ws "Fr") wsAzertyBindings)
        // (lib.concatMapAttrs (bind_ws "Us") wsQwertyBindings)
        // move_focused_wnd "left" "h" "h"
        // move_focused_wnd "down" "j" "j"
        // move_focused_wnd "up" "k" "k"
        # semicolumn
        // move_focused_wnd "right" "l" "l"

        // {
          # The side buttons move the window around
          "button9" = "move left";
          "button8" = "move right";

          # change container layout (stacked, tabbed, default)
          "$GroupFr+$mod+ampersand" = "layout toggle tabbed stacking";
          "$GroupUs+$mod+1" = "layout toggle tabbed stacking";

          "$GroupFr+$mod+apostrophe" = "kill";
          "$GroupUs+$mod+4" = "kill";

          "$mad+t" = "floating toggle";
          "$mod+y" = "sticky toggle; exec ${lib.getExe pkgs.libnotify}";
          # "$mod+t" = "exec ${lib.getExe pkgs.voxinput} write; exec ${notify-send} 'voxinput write'";
          # 2. Select a text box you want to speak into and use a global shortcut to run the following
          # 3. Begin speaking, when you pause for a second or two your speach will be transcribed and typed into the active application.
          # "$mod+Shift+t" = "exec ${lib.getExe pkgs.voxinput} record; exec ${notify-send} 'voxinput record'";

          # split in vertical orientation
          "$mod+v" = "split toggle";

          # different focus for windows
          "$mod+$kleft" = "focus left";
          "$mod+$kdown" = "focus down";
          "$mod+$kup" = "focus up";
          "$mod+$kright" = "focus right";

          # toggle tiling / floating
          "$mod+Shift+space" = "floating toggle";
          # change focus between tiling / floating windows
          "$mod+space" = "focus mode_toggle";

          # alternatively, you can use the cursor keys:
          "$mod+Shift+Left" = "move left";
          "$mod+Shift+Down" = "move down";
          "$mod+Shift+Up" = "move up";
          "$mod+Shift+Right" = "move right";

          "$mod+f" = "fullscreen";
          "$mod+Shift+f" = "fullscreen global";
          "$mod+button3" = "floating toggle";
          "$mod+m" = ''mode "monitors'';
          "$mod+r" = ''mode "resize"'';

          # start a terminal
          "${mod}+Return" = "exec --no-startup-id ${term}";
          "${mod}+Shift+Return" = ''exec --no-startup-id ${rawTerm} -d "$(${../../bin/kitty-get-cwd.sh})"'';

          # Text to speech
          "Ctrl+f1" = "record-myself";

          Menu = "exec ${rofi}/bin/rofi -modi 'drun' -show drun";
          "${mod}+Tab" = "exec ${pkgs.vicinae}/bin/vicinae toggle";

          #### Windows key mappings
          ##############################

          # "${mod}+Tab" = "exec ${rofi}/bin/rofi -modi 'drun' -show drun";
          # TODO dwindow exclusively with WIN
          "${mad}+Tab" = "exec ${pkgs.swayr}/bin/swayr switch-window";
          # ca ne montre rien ?
          # "${mad}+p" = "exec ${lib.getExe pkgs.wofi-pass} ";
          # "${mad}+w" = "exec \"${rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";
          # TODO bind
          # XF86Copy

          # TODO make it a noctalia command
          "${mod}+Ctrl+L" = "exec ${pkgs.tetos.swaylockCmd} ";

          "${mod}+F2" =
            "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark audio --command 'kitty ${lib.getExe' pkgs.rmpc "rmpc"}' ";

          # replace with 'avante' alias ?
          "${mod}+F3" =
            ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 60 --height 50 --mark gp_nvim --command "kitty nvim -cLlmChat" '';

          # "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark neorg-notes --command 'kitty nvim +Notes'  ";

          "${mod}+a" =
            "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark audio --command 'kitty ${lib.getExe' pkgs.rmpc "rmpc"}' ";

          # TODO try with flameshot again ?
          # "--release Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "--release Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";

          # for_window [con_mark="SCRATCHPAD_terminal"] border pixel 1

        }
        // lib.optionalAttrs config.programs.vicinae.enable {
          # vicinae://launch/clipboard/history
          # https://docs.vicinae.com/deeplinks
          "${mod}+Ctrl+h" = "exec ${pkgs.vicinae}/bin/vicinae vicinae://launch/clipboard/history";
          "${mad}+w" = "exec ${pkgs.vicinae}/bin/vicinae deeplink vicinae://launch/wm/switch-windows";
        }
        # // lib.optionalAttrs config.services.clipcat.enable {
        #   "${mod}+Ctrl+h" =
        #     "exec ${pkgs.clipcat}/bin/clipcat-menu -f rofi  | ${sharedConfig.notify-send} 'Failed running clipcat' ";
        # }
        // lib.optionalAttrs config.services.cliphist.enable {
          "${mod}+Ctrl+h" =
            ''exec ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu  -m -1 -p "Select item to copy" -lines 10 -width 35 | cliphist decode | wl-copy | ${sharedConfig.notify-send} 'Failed running cliphist' '';

        }
      # // lib.optionalAttrs config.services.clipman.enable {
      #   "${mod}+Ctrl+h" =
      #     "exec ${pkgs.clipman}/bin/clipman pick -t rofi || ${sharedConfig.notify-send} 'Failed running clipman' ";
      # }
      # todo bind
      # // lib.optionalAttrs config.services.swaync.enable {
      #   "${mad}+l" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
      #   "${mod}+grave" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
      # }
      ;

      startup = [
        # { command = "env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1"; }
        { command = "env RUST_BACKTRACE=1 swaycons"; }

      ]
      # https://docs.noctalia.dev/getting-started/nixos/#running-the-shell
      ++ lib.optional config.programs.noctalia.enable { command = "noctalia"; }
      ++ lib.optional config.services.cliphist.enable { command = "wl-paste --watch cliphist store"; };
    };

    # sharedExtraConfig =
    extraConfigEarly = ''
      set $GroupUs Group1
      set $GroupFr Group2

      set $mod Mod1
      set $rmod Mod1

      # to easily swap between i3/vim mode
      set $kleft h
      set $kdown j
      set $kup k
      set $kright l

      set $term ${term}

      set $w1 1:󰖯
      set $w2 2:
      set $w3 3:
      set $w4 4:qemu
      set $w5 5:misc
      set $w6 6:irc
      set $w7 7
      set $w8 8
      set $w9 9

      # Mod4 => window key
      set $mad Super_L

    '';

    extraConfig = ''
       # as per https://github.com/swaywm/sway/wiki/Systemd-integration
       exec "systemctl --user import-environment {,WAYLAND_}DISPLAY SWAYSOCK; systemctl --user start sway-session.target"

      include ~/.config/sway/conf.d/*.conf
      # host specific
      include ~/.config/sway/`hostname`/*
    '';

    extraOptions = [
      # "--verbose"
      # "--debug"
    ];

    #       export XDG_CURRENT_DESKTOP=sway
    # export XDG_SESSION_DESKTOP=sway
    #

    # describe what it does
    wrapperFeatures = {
      gtk = true;
    };
  };
}
