# look at https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration
{ pkgs, ... }:
{
  enable = true;

  wireplumber.enable = true;
  # wireplumber.configPackages = [
  #   (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
  #     monitor.bluez.properties = {
  #       bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
  #       bluez5.codecs = [ sbc sbc_xq aac ]
  #       bluez5.enable-sbc-xq = true
  #       bluez5.hfphsp-backend = "native"
  #     }
  #   '')
  # ];

  wireplumber.extraConfig."11-bluetooth-policy" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  # Disable everything that causes pipewire to interact with alsa devices
  # https://discourse.nixos.org/t/bluetooth-a2dp-sink-not-showing-up-in-pulseaudio-on-nixos/32447/4
  alsa.enable = true;
  pulse.enable = true;
  jack.enable = true;
  # config.pipewire = {
  #   "properties" = {
  #     default.clock.allowed-rates = [ 44100 48000 96000 ];
  #     "log.level" = 4;
  #     "default.clock.quantum" = 256;
  #     "default.clock.min-quantum" = 256;
  #     "default.clock.max-quantum" = 256;
  #   };
  # };
  # };
}
