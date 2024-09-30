{ dotfilesPath, ... }:
{
  imports = [
    ../../../nixos/profiles/immich.nix
  ];
  services.immich = {
    enable = true;
    machine-learning = { enable = false; };
    # secretsFile
    openFirewall = true;
  };

}
