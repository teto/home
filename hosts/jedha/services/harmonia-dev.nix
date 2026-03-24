{

  # testing nix cache
  daemon.enable = true;

  # The cache will automatically use the daemon when enabled
  cache = {
    enable = true;
    # settings = {
    #       bind = "[::]:5000";
    #       workers = 4;
    #       max_connection_rate = 256;
    #       priority = 50;
    #
    # };

    # TODO write one
    # signKeyPaths = [ "/var/lib/secrets/harmonia.secret" ];
  };
}
