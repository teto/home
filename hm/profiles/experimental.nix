{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
{

  # programs.zsh = {
  #   mcfly.enable = true;
  # };

  programs.xdg.enable = true;

  i18n.inputMethod.fcitx5.waylandFrontend = true;

  # services.trayscale.enable = true;

  programs.swappy.enable = false;

  # services.wl-clip-persist.enable = true;

  programs.vifm.enable = true;

  # home.packages = with pkgs; [ ];

  # programs.htop = {
  #   enabled = true;
  #   settings = {
  #     color_scheme = 5;
  #     delay = 15;
  #     highlight_base_name = 1;
  #     highlight_megabytes = 1;
  #     highlight_threads = 1;
  #   };
  # };
}
