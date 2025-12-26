{
  config,
  pkgs,
  lib,
  ...
}:
{

  # one needs to setup the post-receive hook on the server
  # https://medium.com/zerosum-dot-org/a-pure-git-deploy-workflow-with-jekyll-and-gitolite-b3a48f2ce06f
  # https://github.com/vanderlee/gitolite-hooks/blob/master/post-receive.deploy
  # https://gitolite.com/gitolite/cookbook.html#v36-variation-repo-specific-hooks

  # git clone gitolite@host:gitolite-admin.git

  users.users.gitolite.extraGroups = [
    "www"
    "nginx"
  ];

  # enable gitolite
  services.gitolite = {
    enable = true;
    # read
    adminPubkey = builtins.readFile ./neotokyo-gitolite.pub;
    # group = "";
    # user
    # enableGitAnnex = false;
    # by default dataLib -> /var/lib/gitolite
    # dataDir = /home/teto/gitolite;

    # perl code
    extraGitoliteRc = ''
      $RC{UMASK} = 0027;
      $RC{SITE_INFO}  = 'This is our private repository host';
      $RC{LOCAL_CODE} =  "$rc{GL_ADMIN_BASE}/local",
      push( @{$RC{ENABLE}}, 'repo-specific-hooks'); # enable the command/feature
    '';

    # hooks deployed to every  repo
    # commonHooks = [ ];
  };
}
