{ config, lib, pkgs, ... }:
{
  services.redis = {

    servers.default = {
      enable = true;
      logLevel = "debug";
      # default port is 6379
      port = 0;
      openFirewall = false;
      # passwordFile = "./redis.txt";
      requirePass = "toto";

      # https://redis.io/topics/config
      # https://raw.githubusercontent.com/redis/redis/6.0/redis.conf
      # to enable TLS

      settings = {
        # port = 0; # conflicts with module one

        # tls-port = 4242;
        # tls-cert-file = "${../../data/server.crt}";
        # tls-key-file = "${../../data/server.key}";

        # disable client authentification
        tls-auth-clients = "no";

        # Either tls-ca-cert-file or tls-ca-cert-dir must be specified when tls-cluster, tls-replication or tls-auth-clients are enabled!
        # Configure a CA certificate(s) bundle or directory to authenticate TLS/SSL
        # clients and peers.  Redis requires an explicit configuration of at least one
        # of these, and will not implicitly use the system wide configuration.
        #
        # tls-ca-cert-file = "${../../data/ca.crt}";

        # syslog-enabled = "yes";


  # Configure allowed ciphers.  See the ciphers(1ssl) manpage for more information
  # about the syntax of this string.
  #
  # Note: this configuration applies only to <= TLSv1.2.
  #
        tls-ciphers = "DEFAULT:!MEDIUM";

  # Configure allowed TLSv1.3 ciphersuites.  See the ciphers(1ssl) manpage for more
  # information about the syntax of this string, and specifically for TLSv1.3
  # ciphersuites.
  #
  # tls-ciphersuites TLS_CHACHA20_POLY1305_SHA256

  # When choosing a cipher, use the server's preference instead of the client
  # preference. By default, the server follows the client's preference.
  #
        tls-prefer-server-ciphers = "yes";

      };
    };
  };
}
