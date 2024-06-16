{
  config,
  pkgs,
  secrets,
  options,
  flakeInputs,
  lib,
  ...
}:
{
  users.users.root = {
    # isNormalUser = true; # creates home/ sets default shell
    # uid = 1000;
    # once can set initialHashedPassword too
    # initialPassword = secrets.users.root.defaultPassword;
    # shell = pkgs.zsh;
    # openssh.authorizedKeys.keyFiles = [ ./keys/root_gitolite.pub ];
  };
}
