{
  pkgs,
  flakeSelf,
  ...
}:
{

  # programs.zsh = {
  #   mcfly.enable = true;
  # };

  # programs.code

  programs.chawan.enable = true;

  # programs.lapce.enable = true;
  programs.mods = {
    # disabled because zsh completion took too long
    enable = false;
  };

  # written by teto
  programs.fzf.enableLiveRegex = true;

  programs.xdg.enable = true;

  home.packages = [

    flakeSelf.inputs.lux.packages.${pkgs.system}.lux-cli # fails to build
  ];

  # services.trayscale.enable = true;

  # programs.swappy.enable = false;

  # services.wl-clip-persist.enable = true;

  programs.vifm.enable = true;

  wayland.windowManager.wayfire.enable = false;
  # programs.wayfire.enable = true;

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
