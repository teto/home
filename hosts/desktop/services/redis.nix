{ ... }:
{
  enable = false;
  # _imports = [
  #   ../../../nixos/profiles/redis.nix
  # ];

  servers.test = {

    # bind = null; # bind to all interfaces
    # bind can accept several IPs
    # https://stackoverflow.com/questions/19091087/open-redis-port-for-remote-connections
    # bind = 0.0.0.0
    port = 6379;

    logfile = "stdout"; # defaults to "/dev/null"

    # Alternatively
    # requirePassFile = "./redis.txt";
    # requirePass = "toto";
    # vmOverCommit = 1;
  };
}
