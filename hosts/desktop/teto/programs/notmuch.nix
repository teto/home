{
  config,
  lib,
  pkgs,
  ...
}:
{

  # TODO conditionnally define these
  programs.notmuch = {
    enable = true;

    # dont add "inbox" tag
    new.tags = [
      "unread"
      "inbox"
    ];
    # new.ignore = 
    search.excludeTags = [ "spam" ];

    # or we could use mkOutOfStoreSymlink ?
    hooks = {
      postNew = lib.concatStrings [ (builtins.readFile ../../../../hooks_perso/post-new) ];
      # postInsert = 
    };
  };

}
