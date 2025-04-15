{ flakeSelf, pkgs, ... }:
let
  myLib = pkgs.tetoLib;

in
{
  enable = true;

  # package = flakeSelf.inputs.waybar.packages.${pkgs.system}.waybar;
  systemd.enable = true;

  settings = {
    mainBar = {
      fixed-center = false;
      # a way to have a manual definition !
      include = [ "~/.config/waybar/common.jsonc" ];

      wireplumber = {
        format = "{volume}% {icon}";
        # 🔈
        format-muted = "<span background='red'>🔇</span>";
        on-click = myLib.muteAudio;
        format-icons = [
          "🔈"
          "🔉"
          "🔊"
        ];
      };
      "custom/weather" = {
        # https://fontawesome.com/icons/cloud?f=classic&s=solid
        format = " {}  ";
        tooltip = true;
        interval = 3600;
        # --hide-conditions
        # pass location
        exec = "${pkgs.wttrbar}/bin/wttrbar";
        return-type = "json";
      };
    };
  };
}
