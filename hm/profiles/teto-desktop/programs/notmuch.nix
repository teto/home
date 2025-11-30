{
  config,
  lib,
  pkgs,
  withSecrets,
  ...
}:
{

  # enabling it
  # - teto profile: notmuch: Must have a user name set.
  # - teto profile: notmuch: Must have a user primary email address set.
  enable = withSecrets;

  # dont add "inbox" tag
  new.tags = [
    "unread"
    "inbox"
  ];
  # new.ignore =
  search.excludeTags = [ "spam" ];

  # or we could use mkOutOfStoreSymlink ?
  # database.hook_dir
  hooks = {
    # the HM module wraps these scripts with NOTMUCH_CONFIG / PATH and so on which is why I can't pass a string
    postNew = lib.concatStrings [
      # TODO move them up to a "mail" section ? or to config/notmuch
      (builtins.readFile ./notmuch_hook_perso_post-new)
    ];
    # postInsert =
  };

}
