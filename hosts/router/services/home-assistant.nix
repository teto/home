{
  flakeSelf,
  pkgs,
  lib,
  config,
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
          url = "https://gist.github.com/markkvdb/9ce600a7ceee95f52c013df985803f9d";
          hash = "sha256-yI4AjxgRR4cpa9Cw0gfX6ejtXx4r93wDiZ2Pg6WYy5k=";
        })
      ];

      # templates = {};
    };
  };

  systemd.services.home-assistant.serviceConfig = lib.mkIf config.services.home-assistant.enable {
    # on-failure
    # when there are not enough space failure
    # Restart = lib.mkForce "always";
  };
}
