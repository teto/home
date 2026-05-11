{
  # pkgs,
  # flakeSelf,
  ...
}:
{
  nix = {

    distributedBuilds = true;

    settings = {
      #   # http-connections = 25 is the default
      #   http2 = true;
      # show-trace = false;
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      preallocate-contents = true;
      warn-large-path-threshold = "10M";
      log-lines = 20;
      use-registries = true;
      warn-dirty = true;

      # was problematic for a while
      use-cgroups = false;

      # starting from nix 2.30
      trace-import-from-derivation = true;

      keep-outputs = true; # Nice for developers
      keep-derivations = true; # Idem
      keep-failed = true;

      # experimental-features = nix-command flakes auto-allocate-uids
      extra-experimental-features = "auto-allocate-uids nix-command flakes cgroups";

      substituters = [
      ];

      trusted-substituters = [
      ];
      trusted-public-keys = [
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
