{ config, pkgs, lib,  ... }:
let

  # https://nixos.org/channels/nixos-unstable
  unstable = import <nixos-unstable> {};

  i3pystatus-custom = pkgs.i3pystatus-perso.override ({
    extraLibs = with pkgs.python3Packages; [ pytz notmuch dbus-python ];
  });

  # or use {pkgs.kitty}/bin/kitty
  term = "kitty";


  sharedExtraConfig = ''
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

      workspace_auto_back_and_forth true
      show_marks yes

      set $w1 1:
      set $w2 2:
      set $w3 3:
      set $w4 4:qemu
      set $w5 5:misc
      set $w6 6:irc
      set $w7 7
      set $w8 8
      set $w9 9

      # experimental part about
      # Mod4 => window key
      set $mad Super_L
      # Mod4

      # https://faq.i3wm.org/question/5942/using-modifer-key-as-a-binding/
      # https://faq.i3wm.org/question/5429/stay-in-mode-only-while-key-is-pressed/
      # set $set_mark  /home/teto/.i3/set_marks.py
      #bindsym $mad exec notify-send "XP mode"; mode "xp"; exec $set_mark

      # The middle button over a titlebar kills the window
      bindsym --release button2 kill


      # bindsym $mod+shift+e exec /home/teto/i3-easyfocus/easyfocus

      # The side buttons move the window around
      bindsym button9 move left
      bindsym button8 move right


      # Tests for title_format
      # give the focused window a prefix
      # bindsym $mod+Shift+g title_format "[test] %title"

      for_window [class="^qutebrowser$"] title_format "<span background='blue'>QB</span> %title"
      for_window [class="^Firefox$"] title_format "<span background='#F28559'>FF</span> %title"
      for_window [title="Thunderbird$"] title_format " %title"

      # class                 border,  backgrd,  text,    indicator,  child border
      # client.focused          $focused_border $client_bg #FFFF50
      # client.focused_inactive $focused_border_inactive  $focinac_bg $focinac_txt  #090e14
      # client.unfocused        $unfocused_border $unfocused_border_bg $unfocused_txt #090e14
      # client.urgent           #870000 #870000 #ffffff #090e14
      # client.background       $client_bg
      # # client.background       #66ff33

      # client.placeholder  #000000 #0c0c0c #ffffff #000000   #0c0c0c

    ''
    + (lib.concatStrings [
      (builtins.readFile ../../config/i3/config.main)
      # (builtins.readFile ../../config/i3/config.xp)
    ]);
in
{
  imports = [
    ../lib/colors.nix
  ];

  xsession.windowManager.i3 =
  let
    bind_ws = workspace_id: fr: us:

    let ws = builtins.toString workspace_id;
    in
      {
        "$GroupFr+$mod+${fr}"="workspace \"$w${ws}\"";
        "$GroupUs+$mod+${us}"="workspace \"$w${ws}\"";
        "$GroupFr+Shift+$mod+${fr}"=''move container to workspace "$w${ws}"'';
        "$GroupUs+Shift+$mod+${us}"=''move container to workspace "$w${ws}"'';
      };
    in
  {
    enable = true;

    # bindsym $mod+ctrl+v exec ~/vim-anywhere/bin/run"
    extraConfig = sharedExtraConfig
      + (lib.concatStrings [
        (builtins.readFile ../../config/i3/config.colors)
      ])
      + ''
        new_float pixel 2
      ''

    ;

    # prefix with pango if you want to have fancy effects
    config = {
      terminal = term;
      workspaceAutoBackAndForth = true;

      colors = {
      # class                 border,  backgrd,  text,    indicator,  child border
      # client.focused          $focused_border $client_bg #FFFF50
      # client.urgent           #870000 #870000 #ffffff #090e14
      # client.background       $client_bg
      # # client.background       #66ff33

      # client.placeholder  #000000 #0c0c0c #ffffff #000000   #0c0c0c

        background = "#d70a53";
        # focused_inactive = 

      # client.focused          $focused_border $client_bg #FFFF50
        focused = {
          border = "#C043C6";
          background = "#d70a53";
          text = "#FFFF50";
          indicator = "#FFFF50";
          childBorder = "white";
        };
      # client.focused_inactive $focused_border_inactive  $focinac_bg $focinac_txt  #090e14
        focusedInactive = {
          border = "#06090d";
          background = "#06090d";
          text = "#696f89";
          indicator = "#090e14";
          childBorder = "red";
        };

      # client.unfocused        $unfocused_border $unfocused_border_bg $unfocused_txt #090e14
        unfocused = {
          border = "#605C57"; # "#C043C6";
          background = "#605C57";
          text = "#ffffff";
          indicator  = "#090e14";
          childBorder = "red";
        };

        urgent = {
          border = "#870000";
          background = "#870000";
          text = "#ffffff";
          indicator = "#090e14";
          childBorder = "red";
        };

      };

      focus.followMouse = false;
      fonts = [ "pango:FontAwesome 12" "Terminus 10" ];
      bars = [
        {
          position="top";
          workspaceButtons=true;
          workspaceNumbers=false;
          id="0";

          # command="";
          statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
        }
      ];
      keycodebindings= { };
      # todo use assigns instead
      startup=[
        # TODO improve config/config specific
        { command= "setxkbmap -layout us"; always = true; notification = false; }
        # { command= "xkblayout-state set +1"; always = false; notification = false; }
        # todo convert to a HM stuff
        ];

# bindsym $mod+m  mode "monitors"
# mode "monitors" {

# 	# todo should work with hjkl too
# 	bindsym $mod+Left move workspace to output left
# 	bindsym $mod+Right move workspace to output right
# 	bindsym $mod+Up move workspace to output top
# 	bindsym $mod+Down move workspace to output down

# 	bindsym $mod+Shift+Left workspace prev_on_output
# 	bindsym $mod+Shift+Right workspace next_on_output

# 	bindsym Return mode "default"
# 	bindsym Escape mode "default"
# }

      modes = {
        monitors =
        let
          move_to_output = dir: fr: us:
          {
            "$GroupFr+$mod+${fr}"="move workspace to output ${dir}";
            "$GroupUs+$mod+${us}"="move workspace to output ${dir}";
          };
        in
        {
          "Return"= "mode default";
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
      };

      window = {
        hideEdgeBorders = "smart";
      };
      # colors = {
      #   focused = {
      #     border = "#03a9f4";
      #     background = "#03a9f4";
      #     text = "#eceff1";
      #     indicator = "#ff9800";
      #     childBorder = "#03a9f4";
      #   };
        # };
        #
    # set $mod Mod1
    # il ne comprend pas Super_L

    # consider using lib.mkOptionDefault according to help
    keybindings =
    let
      mad="Mod4";
      mod="Mod1";
      notify-send = "${pkgs.libnotify}/bin/notify-send";

      move_focused_wnd = dir: fr: us:
      {
        "$GroupFr+$mod+Shift+${fr}"="move ${dir}";
        "$GroupUs+$mod+Shift+${us}"="move ${dir}";
      };
    in
    {
      "$mod+f" = "fullscreen";
      "$mod+Shift+f" = "fullscreen global";
      "$mod+button3" = "floating toggle";

    }
    // {
        # change container layout (stacked, tabbed, default)
        "$GroupFr+$mod+ampersand" = "layout toggle";
        "$GroupUs+$mod+1"  = "layout toggle";
        # todo use i3lock-fancy instead
        # alternative is "light"
        "${mod}+ctrl+v" = "exec ${pkgs.bash}/bin/bash ~/vim-anywhere/bin/run";
        "${mod}+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show run\"";
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
        "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
        "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        # "${mod}+ctrl+b" = "exec " + ../buku_run/buku_run;
        "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

        # "${mod}+shift+n" = "exec ${unstable.gnome3.nautilus}/bin/nautilus";
        "${mod}+Shift+1" =  "exec qutebrowser";

      # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"
# bindsym $GroupFr+$mod+eacute i3-list-windows
# bindsym $GroupUs+$mod+2 i3-list-windows

        # "${mod}+shift+q"="exec ${pkgs.gnome3.nautilus}/bin/nautilus";
        "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
        "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";

        # test rofi-randr
        # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

        # XF86AudioNext="exec ${mpc} next; exec notify-send 'Audio next'";
        # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
        # XF86AudioPause exec mpc toggle; exec notify-send "Audio Pause"
      # } // {
        # alsa version
        # XF86AudioRaiseVolume=if home.packages ?  exec amixer -q set Master 2dB+ unmute; exec notify-send "Audio Raised volume"
        # XF86AudioLowerVolume exec amixer -q set Master 2dB- unmute; exec notify-send Audio lowered
        # XF86AudioMute exec amixer -q set Master toggle; exec notify-send "Mute toggle"
        "$GroupFr+$mod+apostrophe"="kill";
        "$GroupUs+$mod+4"="kill";

        "$mod+t" = "floating toggle";
        "$mod+y" = "sticky toggle; exec ${notify-send}";

        "XF86AudioRaiseVolume"=
          "exec --no-startup-id pactl set-sink-volume 0 +5%;exec ${notify-send} --icon=speaker_no_sound -u low -t 1000 'Audio Raised volume'";
        "XF86AudioLowerVolume"="exec --no-startup-id pactl set-sink-volume 0 -5%;exec ${notify-send} -u low 'Audio lowered'";
        "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
        "XF86AudioPlay" = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
        "--release Print" = "exec ${pkgs.scrot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";
        # bindsym --release Print exec "scrot -m '/home/user/Pictures/screenshots/%s_%H%M_%d.%m.%Y_$wx$h.png'"
        # bindsym --release Shift+Print exec "scrot -s '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
        # bindsym --release $mod+Shift+Print exec "scrot -u -d 4 '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"

# Media player controls
# bindsym XF86AudioPlay exec playerctl play
# bindsym XF86AudioPause exec playerctl pause
# bindsym XF86AudioNext exec playerctl next
# bindsym XF86AudioPrev exec playerctl previous
      }
      // bind_ws 1 "a" "q"
      // bind_ws 2 "z" "w"
      // bind_ws 3 "e" "e"
      // bind_ws 4 "q" "a"
      // bind_ws 5 "s" "s"
      // bind_ws 6 "d" "d"
      // bind_ws 7 "w" "z"
      // bind_ws 8 "x" "x"
      // bind_ws 9 "c" "c"
      // move_focused_wnd "left" "h" "h"
      // move_focused_wnd "down" "j" "j"
      // move_focused_wnd "up" "k" "k"
      # semicolumn
      // move_focused_wnd "right" "l" "l"
      # just trying to overwrite previous bindings with i3dispatch
      // lib.optionalAttrs (pkgs ? i3dispatch ) {
      "${mod}+Left" = "exec ${pkgs.i3dispatch}/bin/i3dispatch left";
      "${mod}+Right" = "exec ${pkgs.i3dispatch}/bin/i3dispatch right";
      "${mod}+Down" = "exec ${pkgs.i3dispatch}/bin/i3dispatch down";
      "${mod}+Up" = "exec ${pkgs.i3dispatch}/bin/i3dispatch up";
      }
    ;
    };
  };

  wayland.windowManager.sway = {
    # enable = true;
    config = (removeAttrs  config.xsession.windowManager.i3.config ["startup" "bars"])
      // {
          input = {
            "type:keyboard" = { xkb_layout = "us,fr"; };

          };

      keybindings = lib.recursiveUpdate config.xsession.windowManager.i3.config.keybindings {
        "$GroupFr+$mod+ampersand" = "layout toggle all";
        "$GroupUs+$mod+1"  = "layout toggle all";

      };

      bars = [
        {
          position="top";
          workspaceButtons=true;
          workspaceNumbers=false;
          # id="0";
          # command="";
          statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
        }
      ];
    };
      # statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";

    extraConfig = sharedExtraConfig + ''
      default_floating_border pixel 2
    '';
  };
}
