{
  flakeSelf,
  lib,
  ...
}:
{

  imports = [
    flakeSelf.homeProfiles.waybar
  ];

  programs.waybar = {
    enable = lib.mkForce false;
    settings = {
      mainBar = {
        include = [
          "~/.config/waybar/desktop.jsonc"
        ];
      };
    };
  };

}
