{ pkgs, ... }:
{
  systemd.user = {
    services = {
      # only if enabled
      # xwayland-satellite = {
      #   Service = {
      #     # TODO need DBUS_SESSION_BUS_ADDRESS
      #     # --app-name="%N" toto
      #     Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
      #     Exec = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      #   };
      # };

    };

    targets = {
      # TODO condition on sway.systemd.enable
      sway-session = {
        Unit.Wants = [ "wayland-session-waitenv.service" ];
      };
    };
  };

}
