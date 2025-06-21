{ pkgs, ...}: 
let 
  rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
  myRofi = pkgs.rofi.override {
  # rofi-wayland-unwrapped;
    inherit rofi-unwrapped;

  plugins = with pkgs; [ 
    rofi-calc
    rofi-bitwarden
    rofi-pass

  ];
};
in 
  myRofi.overrideAttrs({
    name = "rofi-matt-${rofi-unwrapped.version}";
  })

