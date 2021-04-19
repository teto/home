{ config, lib, pkgs, ... }:
{
  services.redis = {
    enable = true;
    logLevel = "debug";

    # default port is 6379
    port = 4242;
    openFirewall = false;
    # passwordFile = "./redis.txt";
    requirePass = "toto";
    # settings = {};
  };
}
