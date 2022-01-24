{ config, lib, pkgs,  ... }:
{

  services.pipewire = {
    enable = true;

    # one or the other
    media-session.enable = false;
    wireplumber.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    config.pipewire = {
      "properties" = {
        #"link.max-buffers" = 64;
	# "link.max-buffers" = 16; # version < 3 clients can't handle more than this
	"log.level" = 2;
        # "default.clock.rate" = 48000; # 44100
        #"default.clock.quantum" = 1024;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 8192;
      };
    };
  };

}
