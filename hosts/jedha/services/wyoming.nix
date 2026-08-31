{ flakeSelf, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.wyoming
  ];

}
