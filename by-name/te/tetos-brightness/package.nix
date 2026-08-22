{
  writeShellApplication,
  pkgs,

}:
writeShellApplication {
  name = "brightness-mgr";
  runtimeInputs = [
    # final.pass-teto
    pkgs.brightnessctl
    pkgs.libnotify # for notify-send
  ];
  # pass up
  text = builtins.readFile ../../../bin/set-brightness.sh;

  checkPhase = ":";
}
