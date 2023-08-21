{...}:
{
  imports = [
    ../../nixos/profiles/redis.nix

  ];

  services.redis.servers.test = {
   # bind = null; # bind to all interfaces
   # bind can accept several IPs
   # https://stackoverflow.com/questions/19091087/open-redis-port-for-remote-connections
   # bind = 0.0.0.0
   port = 6379;

   logfile = "stdout"; # defaults to "/dev/null"
  };
}
