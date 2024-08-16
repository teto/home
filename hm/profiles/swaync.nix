{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.swaync = {
    # enable = true;
    # https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/configSchema.json
    # see gist.github.com/JannisPetschenka/fb00eec3efea9c7fff8c38a01ce5d507
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

    # ne sert a rien
    # systemd.enable = true;

  };

  systemd.user.services.swaync.Service.Environment = [
    # helpful to debug but quite verbose
    # "G_MESSAGES_DEBUG=all"
    "PATH=${
      lib.makeBinPath [
        "/run/current-system/sw"
        pkgs.wlogout
        pkgs.libnotify
        pkgs.swaylock
        pkgs.fuzzel
        pkgs.wofi
        pkgs.wl-clipboard
      ]
    }"
  ];

  xdg.configFile."swaync/config.json".enable = false;
}
