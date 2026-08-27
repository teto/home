{ pkgs, lib, ... }:

let
  server = "tatooine.local";

  customWakeWordModels = pkgs.stdenv.mkDerivation {
    pname = "home-assistant-wakewords-collection";
    version = "6480a05";

    src = pkgs.fetchFromGitHub {
      owner = "fwartner";
      repo = "home-assistant-wakewords-collection";
      rev = "6480a05b5e66905c294e95b9256d1b2e51f7e3d4";
      hash = "sha256-lm20gldJbjBs5t3AdNAMI2c8O4nRM6/wPozohmtGBfI=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir $out
      find . -name "*.tflite" -exec cp -v {} $out/ \;
      runHook postInstall
    '';
  };
in
{
  # Put the hostname or IP address of the device running your Wyoming service (such as Piper, Whisper, or OpenWakeWord
  # so I need only one ?
  services.wyoming.piper.servers = {
    "fr" = {
      enable = true;
      # see https://rhasspy.github.io/piper-samples/#fr_FR-mls-medium
      voice = "fr_FR-mls-medium";
      # voice = "fr_FR-semaine-medium";
      uri = "tcp://${server}:10200";
      # zeroconf
      # useCUDA = pkgs.config.cudaSupport;
    };
  };

  # Looks ok
  services.wyoming.faster-whisper.servers = {
    "medium-en" = {
      enable = true;
      model = "medium-int8";
      language = "en";
      uri = "tcp://${server}:10301";
      # device = "cuda";
    };
  };

  # by default it is on tcp://0.0.0.0:10400
  services.wyoming.openwakeword = {
    enable = true;
    # package = 
    # threshold =
    customModelsDirectories = [
      #customWakeWordModels
    ];
    # preloadModels = [
    #   #"echoh"
    #   "hey_jarvis"
    # ];
  };
}
