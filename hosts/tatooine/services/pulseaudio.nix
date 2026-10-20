{ pkgs, ... }:
    # cant be enabled with pipewire
     {
      # Using PipeWire as the sound server conflicts with PulseAudio. This option requires `services.pulseaudio.enable` to be set to false
      enable = false;
      # for ad2p profle ?
      package = pkgs.pulseaudioFull;
    }

