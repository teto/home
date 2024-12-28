{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeModules.waybar
  ];


    settings = {
      mainBar = {
        include = [ "~/.config/waybar/laptop.jsonc" ];
        # modules-right = [
        #  "battery"
        #  "backlight"
        # ];

        # battery = {
        #   # 'DPL': 'DPL',
        #   # "DIS": "Discharging",
        #   # "CHR": "Charging",
        #   # "FULL": "",

        #  states= {
        #     warning= 10;
        #     critical= 5;
        #  };
        #  format = "{time} {icon}";
        #  # "format"= "{icon} {capacity}%";
        #  format-charging = " {capacity}%";
        #  format-plugged = "{capacity}% ";

        #  format-alt = "{time} {icon}";
        #  format-full = "";
        #  format-icons = ["" "" "" "" ""];
        # };
      };
  };
}
