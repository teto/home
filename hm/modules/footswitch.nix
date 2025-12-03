{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.footswitch;
in
{
  options = {
    programs.footswitch = {
      enable = lib.mkEnableOption "footswitch";

      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };

  # TODO add transcribe mappings to sway

  # TODO generate a systemd startup service/ or a udev thing ?
  # all pedals need to be set
  # scythe -1 -m ctrl -a h -a o -2 -m alt -a f4 -3 -b mouse_double
  #     program the first pedal as Ctrl+h+o, the second pedal as Alt+F4 and the third pedal as double click
  # config = lib.mkIf cfg.enable {
  # ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="XXXX", ATTRS{idProduct}=="YYYY", MODE="0660", GROUP="input", TAG+="uaccess"
  #
  # services.udev.extraRules = ''
  #   # Give tcsd ownership of all TPM devices
  #   KERNEL=="tpm[0-9]*", MODE="0660", OWNER="${cfg.user}", GROUP="${cfg.group}"
  #   # Tag TPM devices to create a .device unit for tcsd to depend on
  #   ACTION=="add", KERNEL=="tpm[0-9]*", TAG+="systemd"
  # '';
  # };

}
