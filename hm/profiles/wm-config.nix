{ config, pkgs, lib, ... }:
let
  # or use {pkgs.kitty}/bin/kitty
  term = "${pkgs.kitty}/bin/kitty";

  # key modifier
  # mad = "Mod4";
  # mod = "Mod1";

  # key modifier
  mad = "Mod4";
  mod = "Mod1";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  # note that you can assign a workspace to a specific monitor !
  bind_ws = layout: workspace_id: fr:
    let ws = builtins.toString workspace_id;
    in
    {
      "$Group${layout}+$mod+${fr}" = ''workspace "''$${ws}"'';
      # "$GroupUs+$mod+${us}" = "workspace \"$w${ws}\"";
      "$Group${layout}+Shift+$mod+${fr}" = ''move container to workspace "''$${ws}"'';
      # "$GroupUs+Shift+$mod+${us}" = ''move container to workspace "$w${ws}"'';
    };

  move_focused_wnd = dir: fr: us:
    {
      "$GroupFr+$mod+Shift+${fr}" = "move ${dir}";
      "$GroupUs+$mod+Shift+${us}" = "move ${dir}";
    };

   wsAzertyBindings = {
	 w1= "a" ;
	 w2= "z" ;
	 w3= "e" ;
	 w4= "q" ;
	 w5= "s" ;
	 w6= "d" ;
	 w7= "w" ;
	 w8= "x" ;
	 w9= "c" ;
   };

   wsQwertyBindings = {
	 w1= "q" ;
	 w2= "w" ;
	 w3= "e" ;
	 w4= "a" ;
	 w5= "s" ;
	 w6= "d" ;
	 w7= "z" ;
	 w8= "x" ;
	 w9= "c" ;
   };

in
{
  sharedKeybindings = {
    # The side buttons move the window around
    "button9" = "move left";
    "button8" = "move right";
    # start a terminal
    "${mod}+Return" = "exec --no-startup-id ${term}";
    # bindsym $mod+Shift+Return exec --no-startup-id ~/.i3/fork_term.sh
    "${mod}+Shift+Return" = ''exec --no-startup-id ${term} -d "$(xcwd)"'';

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
    # "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    "${mod}+Ctrl+L" = "exec ${pkgs.i3lock}/bin/i3lock";

    "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
    "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
    "${mad}+w" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";

    # broken
    # "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
    "${mad}+c" = "exec ${pkgs.rofi-calc}/bin/rofi-calc";
    "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

    "${mod}+Shift+1" = "exec qutebrowser";

    # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"


    # test rofi-randr
    # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

    # XF86AudioNext="exec ${mpc} next; exec notify-send 'Audio next'";
    # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
    # XF86AudioPause exec mpc toggle; exec notify-send "Audio Pause"
    # } // {
    "$GroupFr+$mod+apostrophe" = "kill";
    "$GroupUs+$mod+4" = "kill";

    "$mod+t" = "floating toggle";
    "$mod+y" = "sticky toggle; exec ${notify-send}";

    # split in vertical orientation
    # needs i3next
    "$mod+v" = "split toggle";

    # TODO use id of default sinc
    # icons are set for papirus for now
    # TODO use mpv instead
    XF86AudioPlay = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=media-playback-stop-symbolic -u low 'test'";
    "--release Print" = "exec ${pkgs.flameshot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";
    # "--release Print" = "exec ${pkgs.scrot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";
    # bindsym --release Shift+Print exec "scrot -s '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
    # bindsym --release $mod+Shift+Print exec "scrot -u -d 4 '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
    "$mod+shift+o" = "exec xkill";

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

    # brightnessctl
    XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
    XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";

   } 
   // (lib.concatMapAttrs (bind_ws "Fr") wsAzertyBindings)
   // (lib.concatMapAttrs (bind_ws "Us") wsQwertyBindings)
   // move_focused_wnd "left" "h" "h"
   // move_focused_wnd "down" "j" "j"
   // move_focused_wnd "up" "k" "k"
   # semicolumn
   // move_focused_wnd "right" "l" "l"
   ;
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

        # Mod4 => window key
        set $mad Super_L
        # Mod4

        for_window [title="Thunderbird$"] title_format " %title"

    	# for_window [all] title_window_icon on
    	for_window [class="^Firefox$"] title_window_icon on
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
