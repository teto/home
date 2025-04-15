{
  flakeSelf,
  ...
}:
{

  imports = [
    # flakeSelf.homeProfiles.waybar
  ];

  programs.waybar = {

    settings = {
      mainBar = {
        include = [ "~/.config/waybar/laptop.jsonc" ];
      };
    };
  };
}
