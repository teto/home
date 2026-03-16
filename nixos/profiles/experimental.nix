{
  config,
  lib,
  pkgs,
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

  # not merged yet
  virtualisation.libvirtd.qemu.user = "teto";
}
