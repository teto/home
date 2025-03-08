{
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeModules.waybar
  ];

  programs.waybar = {

    settings = {
      mainBar = {
        include = [ "~/.config/waybar/laptop.jsonc" ];
      };
    };
  };
}
