{
  config,
  lib,
  pkgs,
  secretsFolder,
  ...
}:
{

  settings = {
    substituters = [
      # https://github.com/NixOS/nix/pull/15449
      "http://jedha.local?priority=10&retry-attempts=2&retry-max-delay=1000"
    ];

    # secret-key-files = "${secretsFolder}/nix/tatooine-signing-key";
  };
}
