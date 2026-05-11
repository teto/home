{
  pkgs,
  flakeSelf,
  ...
}:
{

  # programs.zsh = {
  #   mcfly.enable = true;
  # };

  # services.secret-service = {
  #   enable = true;
  # };
  #

  services.voxtype.enable = true;

  # programs.lapce.enable = true;
  # programs.mods = {
  #   # disabled because zsh completion took too long
  #   enable = false;
  # };

  # written by teto
  programs.fzf.enableLiveRegex = true;

  # services.trayscale.enable = true;

  # programs.swappy.enable = false;

  # services.wl-clip-persist.enable = true;

  # programs.vifm.enable = true;
}
