{ pkgs, lib, config, ... }:
let
  secrets = import ../secrets.nix;
in
{

  # dont forget to create the buckets.
  # with minio client:
  # mc mb local/jinko-test
  services.minio = {

    enable = true;
    # Access key of 5 to 20 characters in length that clients use to access the server
    accessKey = "pachyderme";
    browser = true; # to enable browser UI

    # enableGarbageCollect = true;
    # garbageCollectDates
    listenAddress = "0.0.0.0:10000";  # 9000 is the default but already used by the platform
    # region = 
    secretKey = "testtesttest";
  };
}
