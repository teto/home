{ config, lib, pkgs, ... }:
{
    programs.git = {
      enable = true;
      includes = [

        { path = config.xdg.configHome + "/git/manual.gitconfig"; }
      ];

  package = pkgs.gitFull; # to get send-email

  settings = {
    # user = {
    #   email = lib.mkForce "886074+teto@users.noreply.github.com";
    # };
    user = {
      # mkForce due to nova
      name = "Matthieu C.";
      email = lib.mkForce "886074+teto@users.noreply.github.com";
    };

    # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
    credential.helper = "store";
  };

};

programs.flyline.enable = true;
}
