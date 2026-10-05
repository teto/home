{
  writeShellApplication,
  sway,
  jq,
}:
writeShellApplication {
  name = "sway-split-layout";
  runtimeInputs = [
    sway
    jq
  ];
  text = builtins.readFile ./split-layout.sh;
}
