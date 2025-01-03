{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    flakeSelf.homeModules.waybar
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        include = [
          "~/.config/waybar/desktop.jsonc" 
        ];
      };
    };
  };

}
