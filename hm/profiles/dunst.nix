{ config, pkgs, lib,  ... }:
{
  services.dunst = {
    enable = true; # failed to produce output path for output 'out' at 
    settings = {
      global={
        markup="full";
        sticky_history = true;
    # # Maximum amount of notifications kept in history
    # history_length = 20

    # # Display indicators for URLs (U) and actions (A).
        show_indicators = true;
        # TODO move it to module
        # browser = "";
        # dmenu = /usr/local/bin/rofi -dmenu -p dunst:
        alignment = "right";
        geometry = "500x30-30+20";
      };

      shortcuts = {

    # Redisplay last message(s).
    # On the US keyboard layout "grave" is normally above TAB and left
    # of "1". Make sure this key actually exists on your keyboard layout,
    history = "ctrl+grave";
      };


# [shortcuts]

#     # Shortcuts are specified as [modifier+][modifier+]...key
#     # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
#     # "mod3" and "mod4" (windows-key).
#     # Xev might be helpful to find names for keys.

#     # Close notification.
#     close = ctrl+space

#     # Close all notifications.
#     close_all = ctrl+shift+space

#     # Redisplay last message(s).
#     # On the US keyboard layout "grave" is normally above TAB and left
#     # of "1". Make sure this key actually exists on your keyboard layout,
#     history = ctrl+grave
    };
  };

}
