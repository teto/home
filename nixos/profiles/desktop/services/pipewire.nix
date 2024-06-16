{

  # _impots = [ 
  # ];

  # services.pipewire = {
  enable = true;

  # Enable the (deprecated) media-session session manager instead of wireplumber
  wireplumber.enable = true;

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
