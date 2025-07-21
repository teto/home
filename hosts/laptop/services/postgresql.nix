{
  config,
  lib,
  pkgs,
  ...
}:
{
  # _imports = [
  #   ../../nixos/profiles/postgresql.nix
  # ];

  enable = true;
  enableTCPIP = true; # if false, use TCP via localhost only or via socket

  # port par defaut est 5432
  # port = 5555;

  # should be a string
  # initialPasswordFile

  # initialScript = pkgs.writeText "init-sql-script" ''
  #   alter user postgres with password '${postgresPassword}';
  # '';

  # ensureDatabases = [ "core" ];
  # Les mots de passe PostgreSQL sont distincts des mots de passe du système d'exploitation. Le mot de passe de chaque utilisateur est enregistré dans le catalogue système pg_authid. Ils peuvent être gérés avec les commandes SQL CREATE ROLE et ALTER ROLE. Ainsi, par exemple, CREATE ROLE foo WITH LOGIN PASSWORD 'secret';
  # pg_hba.conf is generated through authentication bit
  # sudo cat /var/lib/postgresql/14/pg_hba.conf for a primer
  # "local   all             all                                     md5
  # 'password' is in clear text
  # use password instead of trust ?
  authentication = ''
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    host    all             all             samenet            trust
    local   all             all                                peer
  '';

  # of the form map-name system-username database-username
  # identMap = "desktop-map teto postgres";

}
