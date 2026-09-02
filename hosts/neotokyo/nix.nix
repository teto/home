{ config, ... }:
{
  # _imports =

  settings = {
    log-lines = 60;
    preallocate-contents = true;

    distributedBuilds = false;

    # Trigger garbage collection below 1 GiB free.
    min-free = 1 * 1024 * 1024 * 1024;

    # Keep collecting until 5 GiB is free.
    max-free = 5 * 1024 * 1024 * 1024;

    keep-failed = false;
    keep-derivations = true; # Idem

    secret-key-files = config.sops.secrets."nix-signing-key".path;
    # TODO read from file ?
    trusted-public-keys = [
      "tatooine-signing-key:T2TGDnv8CCFbIVd75Y+5oriAknm7FXJTLfdC3MOuMyg="
    ];
  };
}
