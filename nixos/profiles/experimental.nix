{
  ...
}:

{

  # experimental
  services.voxinput = {
    enable = true;
    environment = {
      # OPENAI_WS_BASE_URL =
      VOXINPUT_LANG = "fr";
    };
  };

  # services.upmpdcli = {
  #   enable = true;
  #   configuration = {
  #     # see https://man.archlinux.org/man/upmpdcli.conf.5.en
  #     friendlyname = "UpMpd";
  #     mpdhost = "127.0.0.1";
  #
  #
  #     # whether we own mpd queue (default to true)
  #     ownqueue = 1;
  #
  #
  #     mpdport = 6600;
  #     # mpdpassword = ;
  #     # Enable OpenHome services (0/1). This defaults to 1, as OpenHome queuing is superior for most usages. There should be little reason to turn it off.
  #     openhome = 1;
  #     upnpav = 1;
  #
  #
  #     useipv6 = 0;
  #     # use all
  #     upnpiface = "*";
  #     loglevel = 4;
  #     # libupnp/pupnp defaults to using the first free port after 49152. Note that clients do not need to know about the value, which is automatically discovered.
  #     upnpport = 49152;
  #   };
  # };

  # not merged yet
  virtualisation.libvirtd.qemu.user = "teto";
}
