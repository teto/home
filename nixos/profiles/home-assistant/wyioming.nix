{ pkgs, lib, ... }:

let
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
  services.wyoming.piper.servers = {
    "en" = {
      enable = true;
      voice = "en_GB-semaine-medium";
      uri = "tcp://127.0.0.1:10200";
    };
  };

  services.wyoming.faster-whisper.servers = {
    "medium-en" = {
      enable = true;
      model = "medium-int8";
      language = "en";
      uri = "tcp://127.0.0.1:10301";
      device = "cuda";
    };
  };

  services.wyoming.openwakeword = {
    enable = true;
    customModelsDirectories = [
      #customWakeWordModels
    ];
    preloadModels = [
      #"echoh"
      "hey_jarvis"
    ];
  };
}
