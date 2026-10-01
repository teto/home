{
  # config,
  # lib,
  pkgs,
  # flakeSelf,
  ...
}:
{
  imports = [
    # flakeSelf.homeProfiles.teto-desktop
  ];

  home.packages = [
    pkgs.hickory-dns # gives 'dns' executable
  ];
}
