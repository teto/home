{
  config,
  lib,
  pkgs,
  flakeSelf,
  # secretsFolder,
  ...
}:
{

  # package = pkgs.nixVersions.nix_2_34;
  # package = pkgs.nixVersions.nix_2_34;
  package = lib.mkForce flakeSelf.inputs.nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

  settings = {
    substituters = [
      # https://github.com/NixOS/nix/pull/15449
      "http://jedha.local?priority=10&retry-attempts=2&retry-max-delay=1000"
    ];

    # secret-key-files = "${secretsFolder}/nix/tatooine-signing-key";
  };
}
