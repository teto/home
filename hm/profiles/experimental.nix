{ pkgs, lib, config, ... }:
{
  # programs.meli = {
  #   enable = true;
  # };

  programs.aerc = {
    enable = true;
    # .enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };

  programs.xdg.enable = true;

  programs.swappy.enable = false;


  home.packages = with pkgs; [
    sudachidict
    sudachi-rs
  ];


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
