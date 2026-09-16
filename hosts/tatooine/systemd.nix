{ pkgs, ... }:
{
  # user.services.pipewire.environment = {
  # PIPEWIRE_DEBUG = "5";
  # };

  # systemd.user.services.wireplumber.environment = {
  #     WIREPLUMBER_DEBUG="5";
  #   };

  # see https://github.com/NixOS/nixpkgs/issues/562661
  services.alsa-init = {
    description = "Initialize ALSA sound cards and UCM";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      SuccessExitStatus = [
        0
        99
      ];
      ExecStart = "${pkgs.alsa-utils}/bin/alsactl init";
    };
  };
}
