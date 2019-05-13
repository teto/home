{ config, lib, pkgs, ... }:
{

  # my proxy
  networking.proxy = rec {
    allProxy = "http://proxy.iiji.jp:8080/";
    default = "http://proxy.iiji.jp:8080/";
    # ftpProxy = "http://proxy.iiji.jp:8080/";
    # httpProxy = ftpProxy;
    # httpsProxy = ftpProxy;
    # rsyncProxy = ftpProxy;
    noProxy="localhost,127.0.0.1";
  };
}
