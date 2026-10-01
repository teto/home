{
  nix = {

    checkConfig = true;

    settings = {
      experimental-features = "nix-command flakes";
    };
  };
}
