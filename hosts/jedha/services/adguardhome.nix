{ flakeSelf, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.adguardhome
  ];

  enable = false;
}

