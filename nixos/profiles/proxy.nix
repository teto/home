{ config, lib, pkgs, ... }:
{

  # my proxy
  networking.proxy = rec {
    allProxy = "http://proxy.iiji.jp:8080/";
    default = "http://proxy.iiji.jp:8080/";
    # ftpProxy = "http://proxy.iiji.jp:8080/";
    # httpProxy = ftpProxy;
    # httpsProxy = "https://proxy.iiji.jp:8080/";
    # rsyncProxy = ftpProxy;
    noProxy = "localhost,127.0.0.1,.iiji.jp,.iijprj.net,iijgio.jp";
  };
}
