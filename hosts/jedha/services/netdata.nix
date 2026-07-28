{ pkgs, ... }:
{
  enable = false;
  enableAnalyticsReporting = false;
  config = {
    global = {
      "memory mode" = "ram";
      "debug log" = "none";
      "access log" = "none";
      "error log" = "syslog";
      # uncomment to reduce memory to 32 MB
      #"page cache size" = 32;

      # update interval
      "update every" = 15;
      # "default memory mode" = "none"; # can be used to disable local data storage
    };
    ml = {
      # enable machine learning
      enabled = "yes";
    };
  };
  # https://nixos.wiki/wiki/Netdata
  package = pkgs.netdataCloud;
  # pkgs.netdata.override {
  #   withCloudUi = true;
  # };

  configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
    nvidia_smi: yes
  '';

  # systemd.services.netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];
  # services.netdata.
  # claimTokenFile = true;
  # config = {
  #            global = {
  #              "debug log" = "syslog";
  #              "access log" = "syslog";
  #              "error log" = "syslog";
  #            };
  #            };

}
