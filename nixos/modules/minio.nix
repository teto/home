{ pkgs, lib, config, ... }:
let
  secrets = import ../secrets.nix;
in
{

  # TODO disable autostart
  # dont forget to create the buckets.
  # with minio client:
  # mc mb local/jinko-test
  services.minio = {

    enable = false;
    # Access key of 5 to 20 characters in length that clients use to access the server
    # rootCredentialsFile = ;
    # accessKey = "pachyderme";
    # secretKey = "testtesttest";
    browser = true; # to enable browser UI

    # enableGarbageCollect = true;
    # garbageCollectDates
    listenAddress = "0.0.0.0:10000";  # 9000 is the default but already used by the platform

  };
}
