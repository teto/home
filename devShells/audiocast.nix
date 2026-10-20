{ pkgs, ... }:

pkgs.mkShell {
  name = "audiocast";

  packages = with pkgs; [
    python3
    pulseaudio
    ffmpeg
  ];
}
