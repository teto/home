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
          name = "blueprint-4button-switch.yaml";
          url = "https://gist.githubusercontent.com/wujku/33ea9fecbdeb0a82019ec30f9e7b5e63/raw/97975429a6be77ac1de7c824f243e1323a3ae044/4button_scene_switch_zha.yaml";
          hash = "sha256-3tUfgBfC1AQ4z0NmVVdAeOk8oGDCNFntFuv1ZlWDQn0=";
        })
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
