{ flakeSelf, pkgs, ... }:
{
  imports = [
    flakeSelf.nixosProfiles.home-assistant
    # flakeSelf.nixosProfiles.wyoming
  ];

  services.home-assistant = {
    enable = true;

    # TODO add
    # Error occurred loading flow for integration data_grand_lyon: No module named 'data_grand_lyon_ha'

    blueprints = {
      automation = [
      (pkgs.fetchurl {
        url = "https://gist.github.com/markkvdb/9ce600a7ceee95f52c013df985803f9d";
        hash = "";
      })
    ];

  };
  };

  systemd.services.home-assistant.serviceConfig = {
    # on-failure
    # when there are not enough space failure
    Restart = "always";
  };
}
