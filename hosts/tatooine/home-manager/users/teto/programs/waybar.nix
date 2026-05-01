{
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeProfiles.waybar
  ];

  programs.waybar = {

    enable = false;
    settings = {
      mainBar = {
        include = [ "~/.config/waybar/laptop.jsonc" ];
      };
    };
  };
}
