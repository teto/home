{ config, lib, pkgs, ... }:
let
   cfg = config.services.audiocast;
in {
  options = {
    services.audiocast = {
      enable = lib.mkEnableOption "audiocast-stream";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Stream audio to dlna
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {


  # Renderer friendlyName to discover over SSDP
  # Hard-coded AVTransport control URL (skips SSDP discovery)
  # else we give url
  #   ❯ yamaha discover
  # name            host           model    udn
  # Espace Musical  192.168.1.164  R-N800A  uuid:9ab0c000-f668-11de-9976-54b7bd990c6e
  # port 	8082 	Local HTTP port for the stream
  xdg.configFile."audiocast/config" = {
    enable = false;
    text = ''
    [audiocast]
    name = Espace Musical
    # url 	(unset) 	Hard-coded AVTransport control URL (skips SSDP discovery)
    mode = app
    sink = audiocast
    sink_description = AudioCast (DLNA)
  '';
};

  systemd.user.services.audiocast-stream = {
    Unit = {
      Description = "Stream PipeWire audio to a DLNA renderer";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
      Wants = [ "pipewire-pulse.service" ];
    };
    Service = {
      ExecStart = "${pkgs.audiocast-stream}/bin/audiocast-stream";
      Restart = "on-failure";
      # The renderer may be asleep or temporarily off the network. The
      # program exits when discovery fails, so retry without a tight loop.
      RestartSec = 30;
    };
    Install.WantedBy = [ "default.target" ];
  };
  };

}
