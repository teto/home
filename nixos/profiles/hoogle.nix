{ config, lib, pkgs, ... }:
{
  services.hoogle = {
    enable = true;
    port = 9999;
    # haskellPackages = pkgs.haskellPackages;
    packages = hs: with hs; [
      # Package ‘servant-db-postgresql-0.2.2.0’ in /home/teto/nixpkgs/pkgs/development/haskell-modules/hackage-packages.nix:221613 is marked as broken, refusing to evaluate.
      # bson  # broken too
      # lens-tutorial  # broken
      # servant-db-postgresql
      Frames
      aeson
      # amazonka # broken
      # amazonka-s3
      # directory
      foldl
      # haskeline
      http-api-data
      http-media # Network.HTTP.Media 
      ip # broken
      katip
      lens
      optparse-applicative
      repline
      servant
      servant-cli
      servant-client
      servant-client-core
      servant-docs
      servant-server
      servant-swagger
      servant-swagger-ui
      split
      streaming-commons
      swagger2
      vector
      vinyl
    ];
  };
}
