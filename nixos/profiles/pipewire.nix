{
  config,
  lib,
  pkgs,
  ...
}:
{

  environment.systemPackages = [
    # pkgs.wayland-pipewire-idle-inhibit # broken not sure how to use it yet
  ];

  # to avoid the "can't find pactl" at launch (if exists ?) should go into hm profile too
  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudioFull ];
}
#"link.max-buffers" = 64;
# "link.max-buffers" = 16; # version < 3 clients can't handle more than this
# https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Troubleshooting
# 4 or 5 should be verbose enough
# PIPEWIRE_DEBUG=5 <app> 2>log

#"default.clock.quantum" = 1024;
#"default.clock.min-quantum" = 32;
#"default.clock.max-quantum" = 8192;
# "pulse.min.req" = 0.021333;
