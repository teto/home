{ pkgs, lib, config, ... }:
{
  # programs.meli = {
  #   enable = true;
  # };

  # nix = {
  #   registry = {
  #     nur.to = { type = "github"; owner = "nix-community"; repo="NUR"; };
  #     hm.to = { type = "github"; owner = "nix-community"; repo="home-manager"; };
  #     poetry.to = { type = "github"; owner = "nix-community"; repo="poetry2nix"; };
  #     neovim.to = { type = "github"; owner = "neovim"; repo="neovim?dir=contrib"; };
  #   };
  # };

  programs.ranger = {
    enable = true;
    # plugins = [];
    # loadDefaultRc
  };

  programs.aerc = {
    enable = true;
    # .enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };

  programs.xdg.enable = true;

  programs.gnome-shell.enable = true;

  # programs.joshuto.enable = true;

  home.packages = with pkgs; [
	# openlens # not in unstable yet 
	# haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720
    # meli  # broken jmap mailreader
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
