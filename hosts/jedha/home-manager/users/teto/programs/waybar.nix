{
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeProfiles.waybar
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
