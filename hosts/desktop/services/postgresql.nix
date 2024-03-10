{ config, flakeInputs, lib, pkgs, ... }:
{
  # imports = [
  #   ../../nixos/profiles/postgresql.nix
  # ];

    enable = true;
    enableTCPIP = true;
    # port par defaut est 5432
    # port = 5555;

    # should be a string
    # initialPasswordFile

    # enableTCPIP = true; # if false, use TCP via localhost only or via socket
            # initialScript = pkgs.writeText "init-sql-script" ''
            #   alter user postgres with password '${postgresPassword}';
            # '';

   # ensureDatabases = [ "core" ];

    # pg_hba.conf is generated through authentication bit
    # sudo cat /var/lib/postgresql/14/pg_hba.conf for a primer
      # "local   all             all                                     md5
      # 'password' is in clear text
    authentication = ''
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    host    all             all             samenet            password
    local   all             all                                peer
    '';

    # of the form map-name system-username database-username
    # identMap = "desktop-map teto postgres";

}

