{
  pkgs,
  flakeSelf,
  ...
}:
{
  nix = {

    distributedBuilds = true;

    # pkgs.nixVersions.nix_2_32;
    package = flakeSelf.inputs.nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      #   # http-connections = 25 is the default
      #   http2 = true;
      # show-trace = false;
      builders-use-substitutes = true;
      use-xdg-base-directories = true;

      keep-outputs = true; # Nice for developers
      keep-derivations = true; # Idem
      keep-failed = true;

      # experimental-features = nix-command flakes auto-allocate-uids
      extra-experimental-features = "auto-allocate-uids nix-command flakes cgroups";

      substituters = [
        # "https://nix-community.cachix.org"
      ];

      trusted-substituters = [
        "https://haskell-language-server.cachix.org"
      ];
      trusted-public-keys = [
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      ];
      # trusted-users = [ "teto" ];
    };
  };
}
