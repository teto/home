{ pkgs, ... }:
{
  systemd.user = {
    services = {

    };

    targets = {
      # TODO condition on sway.systemd.enable
      sway-session = {
        Unit.Wants = [ "wayland-session-waitenv.service" ];
      };
    };
  };

}
