{ config, pkgs, lib,  ... }:
let

        # basePaths = [
        #   "/run/current-system/sw"
        #   config.home.profileDirectory
        #   cfg.iconTheme.package
        # ] ++ optional useCustomTheme hicolorTheme.package;

        # themes = [ cfg.iconTheme ] ++ optional useCustomTheme
        #   (hicolorTheme // { size = cfg.iconTheme.size; });

        # categories = [
        #   "actions"
        #   "animations"
        #   "apps"
        #   "categories"
        #   "devices"
        #   "emblems"
        #   "emotes"
        #   "filesystem"
        #   "intl"
        #   "legacy"
        #   "mimetypes"
        #   "places"
        #   "status"
        #   "stock"
        # ];

        # mkPath = { basePath, theme, category }:
        #   "${basePath}/share/icons/${theme.name}/${theme.size}/${category}";
      # mkIconPath = concatMapStringsSep ":" mkPath (cartesianProductOfSets {
        # basePath = basePaths;
        # theme = themes;
        # category = categories;
      # });
in 
{
  # you can use dunstctl to control stuff
  # to debug dunst: -verbosity debug
  # icon_path is generated from icon_theme or set manually
  services.dunst = {
    enable = true; # failed to produce output path for output 'out' at 

	# iconTheme = {
	# 	package = pkgs.gnome.adwaita-icon-theme;
	# 	name = "Adwaita";
	# }; 

	iconTheme = {
		package = pkgs.papirus-icon-theme;
		name = "Papirus";
		size = "symbolic";
	}; 

    settings = {
      global={
        markup="full";
        sticky_history = true;
      # icon_path = let
      #   useCustomTheme = cfg.iconTheme.package != hicolorTheme.package
      #     || cfg.iconTheme.name != hicolorTheme.name || cfg.iconTheme.size
      #     != hicolorTheme.size;

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
