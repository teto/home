{ flakeSelf, ... }:
{
  imports = [
    flakeSelf.nixosProfiles.home-assistant
    # flakeSelf.nixosProfiles.wyoming
  ];

  services.home-assistant = {
    enable = true;

    # TODO add
    # Error occurred loading flow for integration data_grand_lyon: No module named 'data_grand_lyon_ha'
  };
}
