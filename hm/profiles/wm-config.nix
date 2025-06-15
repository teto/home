{
  config,
  pkgs,
  lib,
  ...
}:
let
  # or use {pkgs.kitty}/bin/kitty
  term = "${pkgs.kitty}/bin/kitty";

  myLib = pkgs.tetoLib;

  # key modifier
  # mad = "Mod4";
  # mod = "Mod1";

  # key modifier
  mad = "Mod4";
  mod = "Mod1";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  # note that you can assign a workspace to a specific monitor !
  bind_ws =
    layout: workspace_id: fr:
    let
      ws = builtins.toString workspace_id;
    in
    {
      "$Group${layout}+$mod+${fr}" = ''workspace "''$${ws}"'';
      # "$GroupUs+$mod+${us}" = "workspace \"$w${ws}\"";
      "$Group${layout}+Shift+$mod+${fr}" = ''move container to workspace "''$${ws}"'';
      # "$GroupUs+Shift+$mod+${us}" = ''move container to workspace "$w${ws}"'';
    };

  move_focused_wnd = dir: fr: us: {
    "$GroupFr+$mod+Shift+${fr}" = "move ${dir}";
    "$GroupUs+$mod+Shift+${us}" = "move ${dir}";
  };

  wsAzertyBindings = {
    w1 = "a";
    w2 = "z";
    w3 = "e";
    w4 = "q";
    w5 = "s";
    w6 = "d";
    w7 = "w";
    w8 = "x";
    w9 = "c";
  };

  wsQwertyBindings = {
    w1 = "q";
    w2 = "w";
    w3 = "e";
    w4 = "a";
    w5 = "s";
    w6 = "d";
    w7 = "z";
    w8 = "x";
    w9 = "c";
  };

  # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
  # Volume: 0.35
  # ❯ wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4
  # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
  # Volume: 0.40
  audioKeybindings =
    let
      notify-send = "${pkgs.libnotify}/bin/notify-send";
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      mpc = "${pkgs.mpc_cli}/bin/mpc";
      # pkgs.writeShellApplication
      getIntegerVolume = pkgs.writeShellScript "get-volume-as-integer" ''
        volume=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -f2 -d' ')
        ${pkgs.perl}/bin/perl -e "print 100 * $volume"
      '';
      getBrightness = pkgs.writeShellScript "get-volume-as-integer" ''
        # -m => machine
        brightness=$(${pkgs.brightnessctl}/bin/brightnessctl -m info | cut -f4 -d, )
        echo $brightness
      '';

    in
    # { name = "get-volume-as-integer";
    #   runtimeInputs = [ pkgs.wireplumber ];
    #   text = ''
    #   out=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -f2 -d' ')
    #   echo $(( 100 * $out ))
    #   '';
    #   checkPhase = ":";
    # };
    {
      # wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+
      # wpctl get-volume @DEFAULT_AUDIO_SINK@
      # -l to limit max volume
      # -t is timeout in ms
      # -e to avoid keeping notif in history
      XF86AudioRaiseVolume = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2;exec ${notify-send} --icon=audio-volume-high -u low -t 1000 -h int:value:$(${getIntegerVolume}) -e -h string:synchronous:audio-volume 'Audio volume' 'Audio Raised volume'";
      XF86AudioLowerVolume = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-;exec ${notify-send} --icon=audio-volume-low-symbolic -u low -t 1000 -h int:value:$(${getIntegerVolume}) -e -h string:synchronous:audio-volume 'Audio volume' 'Lower audio volume'";

      XF86AudioMute = "exec --no-startup-id ${myLib.muteAudio}";
      # XF86AudioLowerVolume = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%;exec ${notify-send} --icon=audio-volume-low-symbolic -u low 'Audio lowered'";
      # XF86AudioMute = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";

      # brightnessctl brightness-low
      XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%; exec ${notify-send} --icon=brightness -u low -t 1000 -h int:value:$(${getBrightness}) -e -h string:synchronous:brightness-level 'Brightness' 'Raised brightness'";
      XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-; exec ${notify-send} --icon=brightness-low -u low -t 1000 -h int:value:$(${getBrightness}) -e -h string:synchronous:brightness-level 'Brightness' 'Lowered brightness'";
      # XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";

      # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

      Mod4 = "exec anyrun";

      XF86AudioNext = "exec ${mpc} next; exec notify-send --icon=forward -h string:synchronous:mpd 'Audio next'";
      XF86AudioPrev = "exec ${mpc} next; exec notify-send --icon=backward -h string:synchronous:mpd 'Audio previous'";
      # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
      XF86AudioPlay = "exec ${mpc} toggle; exec notify-send --icon=play-pause -h string:synchronous:mpd 'mpd' 'Audio Pause' -e ";
      # XF86AudioPause (pas presente sur mon clavier ?

      XF86AudioStop = "exec ${mpc} stop; exec notify-send --icon=stop -h string:synchronous:mpd 'Stopped Audio' -e";

      # XF86AudioPlay = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=media-playback-stop-symbolic -u low 'test'";
    };

in
{
  inherit notify-send;
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
  };
  # }}}

  sharedKeybindings =
    {
      # The side buttons move the window around
      "button9" = "move left";
      "button8" = "move right";
      # start a terminal
      "${mod}+Return" = "exec --no-startup-id ${term}";
      # bindsym $mod+Shift+Return exec --no-startup-id ~/.i3/fork_term.sh

      # change container layout (stacked, tabbed, default)
      "$GroupFr+$mod+ampersand" = "layout toggle";
      "$GroupUs+$mod+1" = "layout toggle";
      # todo use i3lock-fancy instead
      # alternative is "light"
      # "${mod}+ctrl+v" = "exec ${pkgs.bash}/bin/bash ~/vim-anywhere/bin/run";

      "${mod}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'drun,window,ssh' -show drun\"";
      "${mod}+Ctrl+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'window' -show run\"";
      # TODO dwindow exclusively with WIN

      "${mad}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";
      "${mad}+a" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";

      # "${mad}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show window\"";

      # locker

      # broken
      # "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
      "${mad}+c" = "exec ${pkgs.rofi-calc}/bin/rofi-calc";

      "${mod}+Shift+1" = "exec qutebrowser";

      # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"

      # test rofi-randr
      # } // {
      "$GroupFr+$mod+apostrophe" = "kill";
      "$GroupUs+$mod+4" = "kill";

      "$mod+t" = "floating toggle";
      "$mod+y" = "sticky toggle; exec ${notify-send}";

      # split in vertical orientation
      # needs i3next
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

    }
    // (lib.concatMapAttrs (bind_ws "Fr") wsAzertyBindings)
    // (lib.concatMapAttrs (bind_ws "Us") wsQwertyBindings)
    // move_focused_wnd "left" "h" "h"
    // move_focused_wnd "down" "j" "j"
    // move_focused_wnd "up" "k" "k"
    # semicolumn
    // move_focused_wnd "right" "l" "l"
    // audioKeybindings;
  # just trying to overwrite previous bindings with i3dispatch
  # // lib.optionalAttrs (pkgs ? i3dispatch ) {
  # "${mod}+Left" = "exec ${pkgs.i3dispatch}/bin/i3dispatch left";
  # "${mod}+Right" = "exec ${pkgs.i3dispatch}/bin/i3dispatch right";
  # "${mod}+Down" = "exec ${pkgs.i3dispatch}/bin/i3dispatch down";
  # "${mod}+Up" = "exec ${pkgs.i3dispatch}/bin/i3dispatch up";
  # }
  # # The middle button over a titlebar kills the window
  # bindsym --release button2 kill

  # config shared between i3 and sway
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

    set $w1 1:󰖯
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

    # Mod4 => window key
    set $mad Super_L
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
}
