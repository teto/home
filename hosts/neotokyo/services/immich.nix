{ dotfilesPath, ... }:
{
  imports = [
    ../../../nixos/profiles/immich.nix
  ];
  services.immich = {
    enable = true;
  };

}
