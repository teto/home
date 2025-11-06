{
  pkgs,
  flakeSelf,
  ...
}:
{
  nix = {

    distributedBuilds = true;

    package = pkgs.nixVersions.nix_2_31
    # flakeSelf.inputs.nix-schemas.packages.${pkgs.system}.nix
    ;

    buildMachines = [
      {
      }

    ];

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

      extra-substituters = [
        "https://haskell-language-server.cachix.org"
      ];
      trusted-public-keys = [
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      ];
      # trusted-users = [ "teto" ];
    };
  };
}
