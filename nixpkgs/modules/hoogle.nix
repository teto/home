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
      katip
      servant
      servant-server
    ];
  };
}
