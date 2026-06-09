{ config, ... }:
{
  secrets = {

    # I added it to secretsFolder instead
    # "wg-key-vps" = {
    #   # for permission, see man systemd.netdev
    #   mode = "640";
    #   owner = "systemd-network";
    #   group = "systemd-network";
    # };
  };

}
