{
  config,
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
  };
}
