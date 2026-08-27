{ flakeSelf, ... }:
{
  imports = [
    flakeSelf.nixosProfiles.home-assistant
    # flakeSelf.nixosProfiles.wyoming
  ];

  services.home-assistant = {
    enable = true;
  };

}
