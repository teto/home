{
  config,
  secrets,
  # flakeSelf,
  # pkgs,
  ...
}:
{

  # ediff = false;
  # package = flakeSelf.inputs.jujutsu.packages.${pkgs.stdenv.hostPlatform.system}.jujutsu;

  enable = true;
  settings = {
    aliases = {
      n = [ "new" ];
      nt = [
        "new"
        "trunk()"
      ];
    };
    user = {
      email = config.programs.git.settings.user.email;
      name = "teto";
    };
    ui = {
      default-command = "status";
      merge-editor = "nvim";
      # Enable pagination for commands that support it (default)
      paginate = "auto";
    };

    # # this generates what looks like an ok config but jj doesn't seem to care for it
    # "--scope" = [
    #   {
    #     "--when"."repositories" = [ "~/nova" ];
    #     "user" = {
    #       email = secrets.accounts.mail.nova.email;
    #       name = secrets.accounts.mail.nova.displayName;
    #     };
    #     "git" = {
    #
    #       push = "up";
    #       fetch = "up";
    #     };
    #   }
    # ];

    # "--scope.user" = {
    #     email = secrets.accounts.mail.nova.email;
    # };

    # "--scope" = [
    #   {
    #     "--when"."repositories" = [ "~/work/" ];
    #     user.email = "foo@bar";
    #     gpg.key = "/some/apth";
    #   }
    # ];
  };

  # my fork only
  # extraConfig = ''
  #   [[--scope]]
  #   --when.repositories = ["~/nova"]
  #   [--scope.user]
  #   email = "${secrets.accounts.mail.nova.email}"
  #   '';
}
