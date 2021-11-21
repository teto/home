{ config, pkgs, lib,  ... }:
let

  # TODO override extraLibs instead
  i3pystatus-perso = (pkgs.i3pystatus.override({
    extraLibs = with pkgs.python3Packages; [ pytz notmuch dbus-python ];
  })).overrideAttrs (oldAttrs: {
    name = "i3pystatus-dev";
    # src = builtins.fetchGit {
    #   url = https://github.com/teto/i3pystatus;
    #   ref = "nix_backend";
    # };

     src = pkgs.fetchFromGitHub {
       repo = "i3pystatus";
       owner = "teto";
       rev="2a3285aa827a9cbf5cd53eb12619e529576997e3";
       sha256 = "sha256-QSxfdsK9OkMEvpRsXn/3xncv3w/ePCGrC9S7wzg99mk=";
     };
  });


  # i3pystatus-custom = pkgs.i3pystatus.override ({
  i3pystatus-custom = i3pystatus-perso.override ({
    extraLibs = with pkgs.python3Packages; [ pytz notmuch dbus-python ];
  });

  # or use {pkgs.kitty}/bin/kitty
  term = "${pkgs.kitty}/bin/kitty";

  # TODO make it a pywalflag

  sharedExtraConfig = ''
      exec_always --no-startup-id setxkbmap -layout us

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

      floating_minimum_size 75 x 50
      floating_maximum_size -1 x -1

      # experimental part about
      # Mod4 => window key
      set $mad Super_L
      # Mod4

      # The middle button over a titlebar kills the window
      bindsym --release button2 kill

      for_window [title="Thunderbird$"] title_format " %title"


      include ~/.config/i3/config.main
      include ~/.config/i3/config.xp
    ''
      # https://faq.i3wm.org/question/5942/using-modifer-key-as-a-binding/
      # https://faq.i3wm.org/question/5429/stay-in-mode-only-while-key-is-pressed/
      # set $set_mark  /home/teto/.i3/set_marks.py
      #bindsym $mad exec notify-send "XP mode"; mode "xp"; exec $set_mark


      # bindsym $mod+shift+e exec /home/teto/i3-easyfocus/easyfocus
      # Tests for title_format
      # give the focused window a prefix
      # bindsym $mod+Shift+g title_format "[test] %title"
    # for_window [class="^qutebrowser$"] title_format "<span background='blue'>QB</span> %title"
    # for_window  title_format "<span background='#F28559'>FF</span> %title"

    ;
in
{
  # see https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/7

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
    # keep it enabled to generate the config
    enable = true;

    # bindsym $mod+ctrl+v exec ~/vim-anywhere/bin/run"
    extraConfig = sharedExtraConfig
      + ''
        new_float pixel 2
      ''

    ;

    # prefix with pango if you want to have fancy effects
    config = {
      terminal = term;
      workspaceAutoBackAndForth = true;

      focus.followMouse = false;
      fonts = {
        # Source Code Pro
        names = [ "Inconsolata Normal" ];
        size = 12.0;
      };
      bars = [
        {
          position="top";
          workspaceButtons=true;
          workspaceNumbers=false;
          id="0";
          statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
        }
      ];
      keycodebindings= { };
      # todo use assigns instead
      startup=[
        # TODO improve config/config specific
        ];


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
          "Escape"= "mode default";
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
            "Return" = ''mode "default"'';
            "Escape" = ''mode "default"'';
        };
      };

      window = {
        hideEdgeBorders = "smart";
      };

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
      "$mod+m"= ''mode "monitors'';
    }
    // {
      # The side buttons move the window around
      "button9" = "move left";
      "button8" = "move right";
      # start a terminal
      "${mod}+Return" = "exec --no-startup-id ${term}";
      # bindsym $mod+Shift+Return exec --no-startup-id ~/.i3/fork_term.sh
      "$mod+Shift+Return" = ''exec --no-startup-id $term -d "$(xcwd)"'';

        # change container layout (stacked, tabbed, default)
        "$GroupFr+$mod+ampersand" = "layout toggle";
        "$GroupUs+$mod+1"  = "layout toggle";
        # todo use i3lock-fancy instead
        # alternative is "light"
        # "${mod}+ctrl+v" = "exec ${pkgs.bash}/bin/bash ~/vim-anywhere/bin/run";
        "${mod}+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'window,drun,run,ssh' -show run\"";
        "${mod}+Ctrl+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'window' -show run\"";
        # TODO dwindow exclusively with WIN
        "Super_L+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show run\"";
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
        "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
        "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        "Super_L+w" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";

        # broken
        # "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
        "${mad}+c" = "exec ${pkgs.rofi-calc}/bin/rofi-calc";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

        "${mod}+Shift+1" =  "exec qutebrowser";

        # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"

        # "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
        # "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";
        # brightnessctl
        # "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10";
        # "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set -10";

        # test rofi-randr
        # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

        # XF86AudioNext="exec ${mpc} next; exec notify-send 'Audio next'";
        # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
        # XF86AudioPause exec mpc toggle; exec notify-send "Audio Pause"
      # } // {
        "$GroupFr+$mod+apostrophe"="kill";
        "$GroupUs+$mod+4"="kill";

        "$mod+t" = "floating toggle";
        "$mod+y" = "sticky toggle; exec ${notify-send}";

        # TODO use id of default sinc
        "XF86AudioRaiseVolume"= "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%;exec ${notify-send} --icon=speaker_no_sound -u low -t 1000 'Audio Raised volume'";
        "XF86AudioLowerVolume"="exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%;exec ${notify-send} -u low 'Audio lowered'";
        "XF86AudioMute"="exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
        # TODO use mpv instead
        "XF86AudioPlay" = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
        "--release Print" = "exec ${pkgs.scrot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";
        # bindsym --release Print exec "scrot -m '/home/user/Pictures/screenshots/%s_%H%M_%d.%m.%Y_$wx$h.png'"
        # bindsym --release Shift+Print exec "scrot -s '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
        # bindsym --release $mod+Shift+Print exec "scrot -u -d 4 '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
        "$mod+shift+o" = "exec xkill";


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
      # // lib.optionalAttrs (pkgs ? i3dispatch ) {
      # "${mod}+Left" = "exec ${pkgs.i3dispatch}/bin/i3dispatch left";
      # "${mod}+Right" = "exec ${pkgs.i3dispatch}/bin/i3dispatch right";
      # "${mod}+Down" = "exec ${pkgs.i3dispatch}/bin/i3dispatch down";
      # "${mod}+Up" = "exec ${pkgs.i3dispatch}/bin/i3dispatch up";
      # }
    ;
    };
  };

  # since we have trouble running i3pystatus
  # programs.i3status-rust.enable = true;

  wayland.windowManager.sway = {
    config = (removeAttrs  config.xsession.windowManager.i3.config ["startup" "bars"])
      // {
          input = {
            "type:keyboard" = {
              xkb_layout = "us,fr";
              xkb_options = "ctrl:nocaps";
              # to swap altwin:swap_lalt_lwin
            };

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
          command="${pkgs.waybar}/bin/waybar";
          statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
          extraConfig = ''
            icon_theme Adwaita
          '';
        }
      ];
    };
      # statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";

    extraConfig = sharedExtraConfig + ''
      default_floating_border pixel 2
    '';
  };
}
