{
  config,
  secrets,
  flakeSelf,
  pkgs,
  ...
}:
{

  # ediff = false;
  package = flakeSelf.inputs.jujutsu.packages.${pkgs.system}.jujutsu;

  enable = true;
  settings = {
    user = {
      # "jdoe@example.org";
      email = config.programs.git.userEmail;
      name = "teto";
    };
    
    # # this generates what looks like an ok config but jj doesn't seem to care for it
    # "--scope" = [ 
    #   {
    #     "--when.repositories" = ["~/nova"];
    #   }
    # ];
    #
    # "--scope.user" = {
    #     email = secrets.accounts.mail.nova.email;
    # };

  };

  # my fork only
  # extraConfig = ''
  #   [[--scope]]
  #   --when.repositories = ["~/nova"]
  #   [--scope.user]
  #   email = "${secrets.accounts.mail.nova.email}"
  #   '';
}
