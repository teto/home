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
        (pkgs.fetchurl {
          name = "blueprint";
          url = "https://gist.githubusercontent.com/markkvdb/9ce600a7ceee95f52c013df985803f9d/raw/eeecd3670a24e4c3efdc22fe30736d7bb176e881/blueprint.yaml";
          # url = "https://gist.github.com/markkvdb/9ce600a7ceee95f52c013df985803f9d";
          hash = "sha256-EriZ1saSSt6xLBtNX2S59oVITrDbQ4CFqk7/t+9qYeA=";
        })
      ];
      # TODO add
      # https://github.com/10der/awtrix-ng-hass-integration
      # template = {};
      # script = {
    };
  };
}
