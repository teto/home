{ secrets, withSecrets, lib, ...}:
{

  settings = {
    substituters = [
      # "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
    ];

    trusted-substituters =  [
        "https://haskell-language-server.cachix.org"
    ] ++ lib.optional withSecrets "https://cache.${secrets.jakky.hostname}"
;

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

}
