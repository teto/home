{ config, pkgs, lib, ... }:
{

  services.postgresql = {
    # enableTCPIP = true; # if false, use TCP via localhost only or via socket
    # /var/lib/postgresql/13/
    # do I really need it to work locally ?
    # port par defaut est 5432
    # port = 5555;

    # should be a string
    # initialPasswordFile


    # pg_hba.conf is generated through authentication bit
    # sudo cat /var/lib/postgresql/14/pg_hba.conf for a primer
      # "local   all             all                                     md5

    # Dont keep it else it is concatenated with the rest and order matters
    # authentication = ''
    #   host    all             all             samenet            password
    #   local all all              peer
    # '';

    # ensureUsers =  [];
    # initdbArgs
    # initialScript = ./postgresql-init.txt;
    settings = {
         log_connections = true;
         log_statement = "all";
         logging_collector = true;
         log_disconnections = true;
         log_destination = lib.mkForce "syslog";
       };

  };

  # see https://www.pgadmin.org/docs/pgadmin4/6.8/config_py.html

  environment.systemPackages = [
    pkgs.dbeaver # java, crashes often
  ];

  # services.pgadmin = {
  #   # this one is painful
  #   # you have to create /var/lib/pgadmin and /var/log/pgadmin
  #   # and give pgadmin:users ownership of both folders
  #   # run the pgadmin pre-start systemd script is easier
  #   # best to use dbeaver instead

  #   enable = false;
  #   initialEmail = "toto@doesnotexist.com";
  #   # "/home/teto/pgadmin.password";
  #   initialPasswordFile = pkgs.writeText "test" "toto";
  # };

}

