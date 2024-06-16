{
  config,
  pkgs,
  lib,
  ...
}:
let
  sharedConfig = pkgs.callPackage ./wm-config.nix { };

  # or use {pkgs.kitty}/bin/kitty
  term = "${pkgs.kitty}/bin/kitty";

in
{
  xsession = {
    # TODO disable when using sway
    enable = true;
    numlock.enable = true;
    # will enable SNI for nm-applet => icon will popup on wayland systray
    preferStatusNotifierItems = true;
    scriptPath = ".hm-xsession";
    # initExtra = 

    # profileExtra = ''
    # '';
  };

  # you can switch from cli with xkb-switch or xkblayout-state
  # this uses setxkbmap
  home.keyboard = {
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    options = [ "add Mod1 Alt_R" ];
  };

  # services.parcellite.enable = true;

  imports = [
    # todo should be disabled if sway enabled 
    # ./dunst.nix
  ];

  home.sessionVariables = {
    # JUPYTER_CONFIG_DIR=

    # this variable is used by i3-sensible-terminal to determine the basic terminal
    # so define it only in i3 ?
    TERMINAL = "kitty";
  };

  home.packages = with pkgs; [
    # xbacklight # for usage with i3pystatus backight module
    # i3-layout-manager  # to save/load layouts
    arandr # to move screens/monitors around
    xclip
    xcwd
    xdotool # needed for vimtex + zathura
    xorg.xbacklight # todo should be set from module
    xorg.xev
  ];

  # todo check if still ok on wayland
  services.greenclip =
    let
      # myGreenclip = with pkgs; haskell.lib.unmarkBroken haskell.packages.ghc884.greenclip;
      myGreenclip = with pkgs; haskellPackages.greenclip;
    in
    {
      enable = true;
      package = myGreenclip;
    };

  # see https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/7
  xsession.windowManager.i3 = {
    # keep it enabled to generate the config
    enable = true;
    enableAudioKeys = true;

    # bindsym $mod+ctrl+v exec ~/vim-anywhere/bin/run"
    # defini ans le sharedExtraConfig as well
    extraConfig =
      builtins.readFile ../../config/i3/config.shared
      + ''

        include ~/.config/i3/manual.i3
        exec_always --no-startup-id setxkbmap -layout us
        exec_always --no-startup-id setxkbmap -option ctrl:nocaps
        new_float pixel 2
      '';

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
      # = rofi ?
      bars = [
        {
          position = "top";
          workspaceButtons = true;
          workspaceNumbers = false;
          id = "0";
          statusCommand = "${pkgs.i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
        }
      ];
      keycodebindings = { };
      # todo use assigns instead
      startup = [
        # TODO improve config/config specific
      ];

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
    };

    # consider using lib.mkOptionDefault according to help
    keybindings =
      let
        inherit (sharedConfig) mod mad;
      in
      {
        # "$mod+f" = "fullscreen";
        # "$mod+Shift+f" = "fullscreen global";
        # "$mod+button3" = "floating toggle";
        # "$mod+m" = ''mode "monitors'';
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
        # "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
        "${mod}+Ctrl+L" = "exec ${pkgs.i3lock}/bin/i3lock";

        "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
        "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        "${mad}+w" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        # icons are set for papirus for now
        "$mod+shift+o" = "exec xkill";

        "${mod}+Shift+Return" = ''exec --no-startup-id ${term} -d "$(xcwd)"'';

      }
      // sharedConfig.sharedKeybindings;
  };

  services.screen-locker = {
    enable = false;
    inactiveInterval = 5; # in minutes
    lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    # xssLockExtraOptions
  };

}
