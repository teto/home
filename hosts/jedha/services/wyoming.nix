{ flakeSelf, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.wyoming
  ];

  # faster-whisper.servers.medium-fr.server.uri = "tcp://${server}:10301";

}
