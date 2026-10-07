/**
  one needs to setup the post-receive hook on the server
  https://medium.com/zerosum-dot-org/a-pure-git-deploy-workflow-with-jekyll-and-gitolite-b3a48f2ce06f
  https://github.com/vanderlee/gitolite-hooks/blob/master/post-receive.deploy
*/
{
  config,
  pkgs,
  ...
}:
{

  # users.users.gitolite.extraGroups = [
  #   "www"
  #   "nginx"
  # ];

  enable = true;

  # by default dataLib -> /var/lib/gitolite
  # dataDir = /home/teto/gitolite;

  keys = {

    # kinda hackish I need something more precise
    teto = map builtins.readFile config.users.users.teto.openssh.authorizedKeys.keyFiles;

    # [
    #   # triggers a access to absolute path '/home/teto/home/perso/keys/id_rsa.pub'
    #   (builtins.readFile "${dotfilesPath}/perso/keys/id_rsa.pub")
    # ];
  };

  # experimental
  repos = {

    blog = {
      access = [
        {
          perm = "RW+";
          users = [ "teto" ];
        }
      ];
      # gitConfig =
      options = {
        "hook.post-receive" = "build-blog";
      };
    };

    cv = {
      access = [
        {
          perm = "RW+";
          users = [ "teto" ];
        }
      ];
      # gitConfig =
      # TODO build CV so it can be used on the blog
      options = {
        "hook.post-receive" = "build-cv";
      };
    };

  };

  # perl code
  # https://gitolite.com/gitolite/cookbook.html#adding-other-non-update-hooks

  # https://gitolite.com/gitolite/cookbook.html#v36-variation-repo-specific-hooks advises to set
  # LOCAL_CODE to store repo-specific hooks
  # /hooks/multi-hook-driver
  # my $driver = $rc{MULTI_HOOK_DRIVER} || "$rc{LOCAL_CODE}/hooks/multi-hook-driver";
  extraGitoliteRc = ''
    $RC{UMASK} = 0027;
    $RC{SITE_INFO}  = 'This is our private repository host';
    $RC{LOCAL_CODE} =  "${pkgs.gitolite-hooks}";
    $RC{MULTI_HOOK_DRIVER} = "${config.services.gitolite.dataDir}/.gitolite/multi-hook-driver";
    push( @{$RC{ENABLE}}, 'repo-specific-hooks'); # enable the command/feature
  '';

  # I had this in my gitolite-admin repo
  # place matching hook in gitolite-admin/conf/gitolite.conf local/hooks/repo-specific/deploy.
  # there is also a git-receive wrapper ?
  # option hook.post-receive = post-receive

  # hooks deployed to every  repo
  # TODO remove it on
  commonHooks = [
    # "${pkgs.gitolite-hooks}/hooks/repo-specific/post-receive"
  ];
}
