{ pkgs, ...}:
{
  enable = true;

  # Enable the (deprecated) media-session session manager instead of wireplumber
  wireplumber.enable = true;
  wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
          bluez5.codecs = [ sbc sbc_xq aac ]
          bluez5.enable-sbc-xq = true
          bluez5.hfphsp-backend = "native"
        }
      '')
    ];


  # Disable everything that causes pipewire to interact with alsa devices
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
