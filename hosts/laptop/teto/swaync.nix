# sway notification center
{ config, lib, pkgs, ... }:
{

 imports = [
   ../../../hm/profiles/swaync.nix
 ];

 # TODO
 services.swaync = {
  enable = true;
# https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/configSchema.json
# see gist.github.com/JannisPetschenka/fb00eec3efea9c7fff8c38a01ce5d507
  settings = {

   # add bluetooth battery
	# "widgets": [
		# "title",
		# "dnd",
		# "mpris",
		# "notifications"
	# ],
	# "widget-config": {
		# "title": {
			# "text": "Notifications",
			# "clear-all-button": true,
			# "button-text": "Clear All"
		# },
		# "dnd": {
			# "text": "Do Not Disturb"
		# },
		# "label": {
			# "max-lines": 5,
			# "text": "Label Text"
		# },
		# "mpris": {
			# "image-size": 96,
			# "image-radius": 12
		# }
	# }

  };

  systemd.enable = true;
 };
 # xdg.configFile."swaync/config.json" = lib.mkForce {};
 # xdg.configFile."swaync/config.json".enable = false;
}
