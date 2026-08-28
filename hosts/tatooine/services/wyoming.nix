{ pkgs, dotfilesPath, ... }:
{
  satellite = {
    enable = true;
    user = "teto";

    microphone = {
      # WebRTC processing emits 10 ms (160-sample) blocks, which are
      # incompatible with pysilero-vad's fixed 512-sample input window.
      autoGain = 0;
      noiseSuppression = 0;
    };

    extraArgs = [
      # pysilero-vad 3.4 requires exactly 512 16 kHz samples per chunk.
      # wyoming-satellite still defaults to 1024, which makes the mic task
      # fail continuously with InvalidChunkSizeError when VAD is enabled.
      "--mic-command-samples-per-chunk"
      "512"

      # Zeroconf attempts multicast on every interface, including WireGuard
      # links whose peers have no multicast key/route (ENOKEY). Home Assistant
      # already connects to the satellite's fixed tcp://...:10700 endpoint.
      "--no-zeroconf"

      "--debug"
      "--wake-word-name alexa"

      # --wake-word-name 'ok_nabu'
    ];

    # refractorySeconds
    sounds = {
      # --awake-wav
      awake = "${dotfilesPath}/data/audio/wake.wav";
      done = "${dotfilesPath}/data/audio/done.wav";
    };

    vad.enable = true; # Whether to enable voice activity detection.
  };
}
