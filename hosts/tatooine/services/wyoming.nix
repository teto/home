{ pkgs, dotfilesPath, ... }:
{
  satellite = {
    enable = true;
    user = "teto";

    #Rather than always streaming audio to Home Assistant, the satellite can wait until speech is detected.
    vad = true;

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

      #  to specify the network address of a remote wake word detection service
      "--wake-uri"
      "tcp://127.0.0.1:10400"
      
      # this disables VAD (Voice AutoDetection) and thus evrything gets streamed to wakeword
      # https://github.com/rhasspy/wyoming-satellite/issues/329
      "--wake-word-name"
      "alexa"
      # [--wake-command WAKE_COMMAND]                                                        ║
      # [--wake-word-name name [pipeline ...]]
      # "--wake-word-name" "alexa"
      # --wake-word-name 'ok_nabu'
    ];

    # refractorySeconds
    sounds = {
      # --awake-wav
      awake = "${dotfilesPath}/data/audio/awake.wav";
      done = "${dotfilesPath}/data/audio/done.wav";
    };

  };
}
