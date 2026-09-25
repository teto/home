{
  config,
  pkgs,
  secrets,
  options,
  lib,
  ...
}:
{
  enable = false; # switched to fish
  zsh-autoenv.enable = false;
  enableCompletion = true;
  enableGlobalCompInit = false;
  # enableAutosuggestions = true;
  autosuggestions = {
    enable = lib.mkForce false;
    # highlightStyle = ""
  };
  # promptInit
  # vteIntegration = false;
  syntaxHighlighting.enable = false;
  shellAliases = config.environment.shellAliases // {
    # tweaks 'time' output
    TIMEFMT = "\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E";
  };

}
