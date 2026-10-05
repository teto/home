{ runCommand }:
runCommand "repo-specific-hooks" {
  version = "0.1";
} ''
  mkdir -p "$out/hooks/repo-specific"
  install -m755 ${./hooks}/* "$out/hooks/repo-specific/"
  patchShebangs "$out/hooks/repo-specific"
''
