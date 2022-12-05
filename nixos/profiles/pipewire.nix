{ config, lib, pkgs, ... }:
{

  services.pipewire = {
    enable = true;

    # Enable the (deprecated) media-session session manager instead of wireplumber
    media-session.enable = true;
    wireplumber.enable = false;

    # Disable everything that causes pipewire to interact with alsa devices
    alsa.enable = false;
    pulse.enable = true;
    jack.enable = false;
    config.pipewire = {
      "properties" = {
        default.clock.allowed-rates = [ 44100 48000 96000 ];
        "log.level" = 4;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 256;
      };
    };
  };

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
