{
  config,
  pkgs,
  lib,
  ...
}:
{


  # git clone gitolite@host:gitolite-admin.git

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

    # perl code
    # extraGitoliteRc
  };

  # then one could activate gitweb
}
