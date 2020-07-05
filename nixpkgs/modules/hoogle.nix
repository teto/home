{ config, lib, pkgs, ... }:
{
  services.hoogle = {
    enable = true;
    port = 9999;
    packages = hs: with hs; [
      http-api-data
      aeson
      amazonka
      amazonka-s3
      # bson  # broken too
      directory
      Frames
      haskeline
      http-media   # Network.HTTP.Media 
      katip
      repline
      servant
      servant-cli
      servant-client
      servant-client-core
      # Package ‘servant-db-postgresql-0.2.2.0’ in /home/teto/nixpkgs/pkgs/development/haskell-modules/hackage-packages.nix:221613 is marked as broken, refusing to evaluate.
      # servant-db-postgresql
      servant-docs
      servant-server
      servant-swagger
      swagger2
      split
      streaming-commons
    ];
  };
}
