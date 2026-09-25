/**
  Wyoming is a small network protocol used by Home Assistant Assist to connect voice-processing services such as:

  - Whisper or Speech-to-Phrase: speech → text
  - Piper: text → speech
  - openWakeWord: wake-word detection

  It is primarily the plumbing between Home Assistant and those services—not the voice assistant itself. Home Assistant’s Wyoming documentation (https://www.home-assistant.io/integrations/wyoming/)

  https://github.com/rhasspy/wyoming-satellite/blob/master/docs/tutorial_2mic.md
  --preload-model 'ok_nabu'

  Add --debug to print additional logs. See --help for more information.

  Included wake words are:

      ok_nabu
      hey_jarvis
      alexa
      hey_mycroft
      hey_rhasspy
*/
{ pkgs, config, ... }:
let
  whisperModelRevision = "c9af9dfadcad017757293c10e4478d42a5a06773";
  whisperModelFile = name: hash: {
    inherit name;
    path = pkgs.fetchurl {
      url = "https://huggingface.co/rhasspy/faster-whisper-medium-int8/resolve/${whisperModelRevision}/${name}";
      inherit hash;
    };
  };
  whisperModel = pkgs.linkFarm "faster-whisper-medium-int8" [
    (whisperModelFile "config.json" "sha256-yd7j1nXDHDdjwe48nnI1BQ6Hfa3ZACxbPGA2bj2B2io=")
    (whisperModelFile "model.bin" "sha256-4Zuj6D5osV1IDe+BhbB/yK9WyqFbuEcPLEfsjB+q7EQ=")
    (whisperModelFile "vocabulary.txt" "sha256-NM4/4cUEECez+NQpEicJk/mG28S7NM8n+VHjSh5FORM=")
    {
      # The int8 repository omits this; without it faster-whisper downloads a tokenizer.
      name = "tokenizer.json";
      path = pkgs.fetchurl {
        url = "https://huggingface.co/Systran/faster-whisper-medium/resolve/08e178d48790749d25932bbc082711ddcfdfbc4f/tokenizer.json";
        hash = "sha256-+3tjGR6bsEUILHn9dCoxBqEsmVE6sw30oNR/pstv0Ks=";
      };
    }
  ];

  # this sometimes resolves to ipv6 ?
  # server = "${config.networking.hostName}.local";

  # hoping mdns resolves to correct address ? since we enforced rules for it ?
  # server = "${config.networking.hostName}.local";
  server = "127.0.0.1";
  # server = "0.0.0.0"; # this can select a fucked up interface like wireguard, I want the local one
  # server = "tatooine.local";

  # customWakeWordModels = pkgs.stdenv.mkDerivation {
  #   pname = "home-assistant-wakewords-collection";
  #   version = "6480a05";
  #
  #   src = pkgs.fetchFromGitHub {
  #     owner = "fwartner";
  #     repo = "home-assistant-wakewords-collection";
  #     rev = "6480a05b5e66905c294e95b9256d1b2e51f7e3d4";
  #     hash = "sha256-lm20gldJbjBs5t3AdNAMI2c8O4nRM6/wPozohmtGBfI=";
  #   };
  #
  #   dontBuild = true;
  #
  #   installPhase = ''
  #     runHook preInstall
  #     mkdir $out
  #     find . -name "*.tflite" -exec cp -v {} $out/ \;
  #     runHook postInstall
  #   '';
  # };
in
{
  # Put the hostname or IP address of the device running your Wyoming service (such as Piper, Whisper, or OpenWakeWord
  # so I need only one ?
  # error while attempting to bind on address ('fe80::d46e:39cc:2a61:7908', 10200, 0, 0): [errno 22] invalid argument
  services.wyoming.piper.servers = {
    fr = {
      enable = true;
      zeroconf.enable = false;
      # see https://rhasspy.github.io/piper-samples/#fr_FR-mls-medium
      voice = "fr_FR-mls-medium";
      # default = "en-us-ryan-medium";
      # voice = "fr_FR-semaine-medium";
      uri = "tcp://${server}:10200";

      # sets device ?
      useCUDA = pkgs.config.cudaSupport;
      extraArgs = [
        # (dont dl from HF)
        "--local-files-only"
      ];
    };
  };

  # Looks ok
  # speech to text
  services.wyoming.faster-whisper.servers = {
    # rename
    medium-fr = {
      enable = true;
      zeroconf.enable = false;
      model = "${whisperModel}";
      sttLibrary = "faster-whisper";
      extraArgs = [ "--local-files-only" ];
      language = "fr";
      uri = "tcp://${server}:10301";
      # device = "cuda";
      # initialPrompt = ''
      #          The following conversation takes place in the universe of
      #          Wizard of Oz. Key terms include 'Yellow Brick Road' (the path
      #          to follow), 'Emerald City' (the ultimate goal), and 'Ruby
      #          Slippers' (the magical tools to succeed). Keep these in mind as
      #          they guide the journey.
      #        ''
    };
  };

  # by default it is on tcp://0.0.0.0:10400
  services.wyoming.openwakeword = {
    # - okay_nabu
    #   - hey_jarvis
    #   - hey_mycroft
    #   - alexa
    #   - hey_rhasspy
    #
    #   The client or Home Assistant pipeline chooses one. For Home Assistant, the conventional
    #   choice is “Okay Nabu” (okay_nabu).

    # annoying eats CPU
    enable = false;
    # package =
    # threshold =
    # area = []
    # extraArgs=
    # triggerLevel = 1;

    # Paths to directories with custom wake word models (*.tflite model files).
    customModelsDirectories = [
      #customWakeWordModels
    ];

    # preloadModels = [
    #   #"echoh"
    #   "hey_jarvis"
    # ];
  };
}
