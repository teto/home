{ config, ... }:
{

  settings = {

    secret-key-files = config.sops.secrets."nix-signing-key".path;
    # TODO read from file ?
    trusted-public-keys = [
      "tatooine-signing-key:T2TGDnv8CCFbIVd75Y+5oriAknm7FXJTLfdC3MOuMyg="
    ];
  };
}
