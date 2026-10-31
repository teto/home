{ config, lib, ... }:
let
  cfg = config.services.minidlna;
  mediaDirs = map (dir:
    let
      prefix = builtins.match "^[A-Za-z]:(.*)$" dir;
    in
    if prefix == null then dir else builtins.head prefix
  ) cfg.settings.media_dir;
in
{
  config = lib.mkIf cfg.enable {
    # Extend the default MiniDLNA module's startup check so an unavailable
    # configured media directory prevents the daemon from starting.
    systemd.services.minidlna.preStart = lib.concatMapStringsSep "\n" (dir: ''
      if [ ! -d ${lib.escapeShellArg dir} ] || [ ! -r ${lib.escapeShellArg dir} ] || [ ! -x ${lib.escapeShellArg dir} ]; then
        echo "MiniDLNA media directory is missing or inaccessible: ${dir}" >&2
        exit 1
      fi
    '') mediaDirs;
  };
}
