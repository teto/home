# sway notification center
{ config, lib, pkgs, ... }:
{

 imports = [
   ../../../hm/profiles/swaync.nix
 ];

 services.swaync = {
  enable = true;

  settings = {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "application";
    control-center-margin-top = 0;
    control-center-margin-bottom = 0;
    control-center-margin-right = 0;
    control-center-margin-left = 0;
    notification-2fa-action = true;
    notification-inline-replies = false;
    notification-icon-size = 64;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    # widgets = [];
# positionX": "right",
	# "positionY": "top",
	# "control-center-margin-top": 20,
	# "control-center-margin-bottom": 0,
	# "control-center-margin-right": 20,
	# "control-center-margin-left": 0,
	# "control-center-width": 500,
	# "control-center-height": 600,
	# "fit-to-screen": false,

	# "layer": "top",
	# "cssPriority": "user",
	# "notification-icon-size": 64,
	# "notification-body-image-height": 100,
	# "notification-body-image-width": 200,
	# "timeout": 10,
	# "timeout-low": 5,
	# "timeout-critical": 0,
	# "notification-window-width": 500,
	# "keyboard-shortcuts": true,
	# "image-visibility": "when-available",
	# "transition-time": 200,
	# "hide-on-clear": true,
	# "hide-on-action": true,
	# "script-fail-notify": true,

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
 xdg.configFile."swaync/config.json".enable = false;
}
