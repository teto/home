{ config, pkgs, lib,  ... }:
let

  # https://nixos.org/channels/nixos-unstable
  unstable = import <nixos-unstable> {};

  i3pystatus-custom = pkgs.i3pystatus-perso.override ({ extraLibs = with pkgs.python3Packages; [ pytz notmuch dbus-python ]; });

  # or use {pkgs.kitty}/bin/kitty
  term = "kitty";
  # term = "termite";
in
{
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
    extraConfig = (lib.concatStrings [
      (builtins.readFile ../../config/i3/config.main)
      (builtins.readFile ../../config/i3/config.xp)
      (builtins.readFile ../../config/i3/config.colors)
    ])
    + ''
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
    ''
    ;

    # prefix with pango if you want to have fancy effects
    config = {
      workspaceAutoBackAndForth = true;

      focus.followMouse = false;
      fonts = [ "pango:FontAwesome 12" "Terminus 10" ];
      bars = let
        # i3pystatus-custom = pkgs.i3pystatus.overrideAttrs (oldAttrs: {
        #   propagatedBuildInputs = with pkgs.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
        # });
          # propagatedBuildInputs = with pkgs.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
        # });
      in [
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
        # { command= "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon"; always = false; notification = false; }
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
        // move_to_output "right" "m" "semicolumn"
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

          # resize ..."

        # # Enter papis mode
        papis = {
          # open documents
          "$mod+o" = "exec python3 -m papis.main --pick-lib --set picktool dmenu open";
          # edit documents
          "$mod+e" = "exec python3 -m papis.main --pick-lib --set picktool dmenu --set editor gvim edit";
          # open document's url
           "$mod+b" = "exec python3 -m papis.main --pick-lib --set picktool dmenu browse";

        #   # return to default mode
        #   bindsym Ctrl+c mode "default"
        #   Return mode "default"
          "Escape" = ''mode "default"'';

        };

        rofi-scripts = {
          # open documents
          "$mod+l" = "sh j";
          # "$mod+e" = "exec python3 -m papis.main --pick-lib --set picktool dmenu --set editor gvim edit";

        #   # return to default mode
        #   bindsym Ctrl+c mode "default"
          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';

        };
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
    }
    // {
        # todo use i3lock-fancy instead
        # alternative is "light"
        # set $greenclip "rofi -modi 'clipboard:greenclip print' -show clipboard"
        "${mod}+ctrl+v" = "exec ${pkgs.bash}/bin/bash ~/vim-anywhere/bin/run";
        "${mod}+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show run\"";
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
        "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
        # "${mod}+ctrl+b" = "exec " + ../buku_run/buku_run;
        "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        # "${mod}+3" = "exec ${pkgs.buku_run}/bin/buku_run";
        # "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

        "$mod+Ctrl+1" = ''mode "papis"'';
        "$mod+Ctrl+p" = ''mode "papis"'';
        # "${mod}+shift+p" = "focus parent";

        # "${mod}+shift+n" = "exec ${unstable.gnome3.nautilus}/bin/nautilus";
        "${mod}+Shift+1" =  "exec qutebrowser";

      # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"
# bindsym $GroupFr+$mod+eacute i3-list-windows
# bindsym $GroupUs+$mod+2 i3-list-windows

        # "${mod}+shift+q"="exec ${pkgs.gnome3.nautilus}/bin/nautilus";
        "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
        "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";

        # TODO use i3
        # test rofi-randr
        # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

# bindsym $mod+ctrl+h exec $greenclip
# bindsym $mod+ctrl+v exec ~/.vim-anywhere/bin/run"

# set $greenclip "rofi -modi 'clipboard:greenclip print' -show clipboard"
#       bindsym $mad+h exec $greenclip
        # TODO let i3dispatch

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
}
