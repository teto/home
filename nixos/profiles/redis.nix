{ config, lib, pkgs, ... }:
{
  services.redis = {

    # servers.default = {
     # creates a redis-test unit ?
    servers.test = {
      enable = true;
      logLevel = "notice";
      # default port is 6379
      # If port 0 is specified Redis will not listen on a TCP socket.
      openFirewall = true;
      # Alternatively
      # requirePassFile = "./redis.txt";
      requirePass = "toto";
      # vmOverCommit = 1;

      # https://redis.io/topics/config
      # https://raw.githubusercontent.com/redis/redis/6.0/redis.conf
      # to enable TLS

      settings = {
        # syslog-enabled = 
        # port = 0; # conflicts with module one

        # tls-port = 4242;
        # tls-cert-file = "${../../data/server.crt}";
        # tls-key-file = "${../../data/server.key}";

        # disable client authentification
        tls-auth-clients = "no";
        tls-ciphers = "DEFAULT:!MEDIUM";
        tls-prefer-server-ciphers = "yes";

      };
    };
  };
}
