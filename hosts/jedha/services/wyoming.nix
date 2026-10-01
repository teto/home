{ flakeSelf, lib, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.wyoming
  ];

  # nginx owns the public Wyoming ports; backends are loopback-only.
  # why would we override themn !?
  # piper.servers.fr.uri = "tcp://127.0.0.1:10201";
  # faster-whisper.servers.medium-fr.uri = "tcp://127.0.0.1:10302";

}
