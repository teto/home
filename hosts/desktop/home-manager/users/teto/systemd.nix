{ pkgs, ... }:
{
  systemd.user.services = {
    xwayland-satellite = {
      Service = {
        # TODO need DBUS_SESSION_BUS_ADDRESS
        # --app-name="%N" toto
        Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
        Exec = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      };
    };

    ollama = {
# OLLAMA_CONTEXT_LENGTH: 32768
# OLLAMA_FLASH_ATTENTION: true
# OLLAMA_KV_CACHE_TYPE: q4_0
      Service = {
        # OLLAMA_KEEP_ALIVE The duration that models stay loaded in memory (default is "5m") 
        Environment = [ "OLLAMA_MODELS=/home/teto/models" ];
      };
    };
  };
}
