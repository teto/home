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

  services.upmpdcli = {
    enable = true;
    configuration = {
      friendlyname = "UpMpd";
      mpdhost = "127.0.0.1";
      mpdport = 6600;
      openhome = 0;
      upnpav = 1;
      upnpport = 49152;
    };
  };

  # not merged yet
  virtualisation.libvirtd.qemu.user = "teto";
}
