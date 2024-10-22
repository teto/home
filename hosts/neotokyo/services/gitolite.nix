{
  config,
  pkgs,
  lib,
  ...
}:
{

  # enable gitolite
  services.gitolite = {
    enable = true;
    # read
    adminPubkey = builtins.readFile ./neotokyo-gitolite.pub;
    # group
    # user
    # enableGitAnnex = false;
    # by default dataLib -> /var/lib/gitolite
    # dataDir = /home/teto/gitolite;
  };

  # then one could activate gitweb
}
