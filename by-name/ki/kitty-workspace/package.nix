{
  writeShellApplication,
  jq,
  sway,
  kitty,
}:
writeShellApplication {
  name = "kitty-for-workspace";
  runtimeInputs = [
    jq
    sway
    kitty
  ];
  text = builtins.readFile ./kitty-for-workspace.sh;
}
