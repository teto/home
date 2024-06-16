{ lib, ... }:
{
  options = {
    enable = lib.mkEnableOption "Title update";

    # enable = mkOption {
    #   default = false;
    #   type = types.bool;
    #   description = ''
    #     To change title
    #   '';
    # };
  };
}
