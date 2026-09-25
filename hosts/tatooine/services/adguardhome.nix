{ flakeSelf, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.adguardhome
  ];
}
