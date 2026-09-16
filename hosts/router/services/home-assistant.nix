{
  flakeSelf,
  pkgs,
  # lib,
  # config,
  ...
}:
{
  imports = [
    flakeSelf.nixosProfiles.home-assistant
  ];

  services.home-assistant = {
    enable = true;

    # TODO add
    # Error occurred loading flow for integration data_grand_lyon: No module named 'data_grand_lyon_ha'

    blueprints = {
      automation = [
        # ATTENTION: The name should contain the extension .yaml
        # else HA ignores it
        (pkgs.fetchurl {
          name = "blueprint-hue-switch.yaml";
          url = "https://gist.githubusercontent.com/markkvdb/9ce600a7ceee95f52c013df985803f9d/raw/eeecd3670a24e4c3efdc22fe30736d7bb176e881/blueprint.yaml";
          # url = "https://gist.github.com/markkvdb/9ce600a7ceee95f52c013df985803f9d";
          hash = "sha256-EriZ1saSSt6xLBtNX2S59oVITrDbQ4CFqk7/t+9qYeA=";
        })

        (pkgs.fetchurl {
          name = "z2m-tuya-4-button-switch.yaml";
          url = "https://raw.githubusercontent.com/lux4rd0/homeassistant/b05ad9cfd0a12173dd5fb750815166b7f5750fd0/blueprints/zigbee2mqtt_tuya_4_button_scene_switch_ts0044_event.yaml";
          # url = "https://gist.github.com/markkvdb/9ce600a7ceee95f52c013df985803f9d";
          hash = "sha256-Ft+w5uiIMuHwoypcBaVesRcaxyhd/v+zkDg97VEMicI=";
        })

        (pkgs.fetchurl {
          name = "Tuya-3button-ts0043.yaml";
          url = "https://raw.githubusercontent.com/maklimcz/HA_blueprints/6c8e90101a26d8bec73894fa6a09a4d287c9b15c/blueprints/Tuya-3button-ts0043.yaml";
          hash = "sha256-Y2A1LmyrE7bm7rRy9xT9mmmDU1uEArxj0YJ5elgiiVM=";
        })

        # works only with ZHA. For z2m see:
        # https://community.home-assistant.io/t/zigbee2mqtt-tuya-4-button-scene-switch-ts0044/274735/172
        # (pkgs.fetchurl {
        #   name = "blueprint-4button-switch.yaml";
        #   url = "https://gist.githubusercontent.com/wujku/33ea9fecbdeb0a82019ec30f9e7b5e63/raw/97975429a6be77ac1de7c824f243e1323a3ae044/4button_scene_switch_zha.yaml";
        #   hash = "sha256-3tUfgBfC1AQ4z0NmVVdAeOk8oGDCNFntFuv1ZlWDQn0=";
        # })

        (pkgs.fetchurl {
          url = "https://github.com/home-assistant/core/raw/2025.1.4/homeassistant/components/automation/blueprints/motion_light.yaml";
          hash = "sha256-4HrDX65ycBMfEY2nZ7A25/d3ZnIHdpHZ+80Cblp+P5w=";
        })

      ];
      # TODO add
      # https://github.com/10der/awtrix-ng-hass-integration
      # template = {};
      # script = {
    };
  };
}
