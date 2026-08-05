{
  secrets,
  withSecrets,
  secretsFolder,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
  # daemonIONiceLevel = 3;
  # prepending with 'flake:' makes HM copy a lot more thna just 'path:'
  nixPath = [
    "nixpkgs=/home/teto/nixpkgs"
  ];

  # either use --option extra-binary-caches http://hydra.nixos.org/
  # handy to hack/fix around
  # readOnlyStore = false;

  # to benefit from https://github.com/NixOS/nix/pull/15449
  # package = flakeSelf.inputs.nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  package = pkgs.nixVersions.latest;

  settings = {
    secret-key-files = "${secretsFolder}/nix/tatooine-signing-key";
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
    ]
    ++ lib.optional withSecrets "https://cache.${secrets.jakku.hostname}";

    trusted-substituters = [
      # "https://haskell-language-server.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="

    ]
    ++
      lib.optional withSecrets
        # "tatooine-signing-key:T2TGDnv8CCFbIVd75Y+5oriAknm7FXJTLfdC3MOuMyg="
        "neotokyo-signing-key:T2TGDnv8CCFbIVd75Y+5oriAknm7FXJTLfdC3MOuMyg=";
    # start-id = 872415232
    trace-import-from-derivation = true;
    # trace-verbose = false;
    keep-outputs = true; # Nice for developers
    keep-derivations = true; # Idem
    keep-failed = true;
  };

}
