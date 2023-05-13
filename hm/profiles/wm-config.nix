{ config, pkgs, lib, ... }:
let
  # or use {pkgs.kitty}/bin/kitty
  term = "${pkgs.kitty}/bin/kitty";

  # key modifier
  # mad = "Mod4";
  # mod = "Mod1";
in
{
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
