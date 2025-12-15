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

  # services.pipewire = ;

  # to avoid the "can't find pactl" at launch (if exists ?) should go into hm profile too
  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];
}
#"link.max-buffers" = 64;
# "link.max-buffers" = 16; # version < 3 clients can't handle more than this
# https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Troubleshooting
# 4 or 5 should be verbose enough
# PIPEWIRE_DEBUG=5 <app> 2>log

# # one or the other
# media-session.enable = false;
# wireplumber.enable = true;

# alsa.enable = true;
# alsa.support32Bit = true;
# pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;
# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;

#"default.clock.quantum" = 1024;
#"default.clock.min-quantum" = 32;
#"default.clock.max-quantum" = 8192;
# "pulse.min.req" = 0.021333;
