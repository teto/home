{
  stdenv,
  fetchFromGitHub,
  rofi,
}:

stdenv.mkDerivation {
  # TODO make it as a function ?
  pname = "rofi-scripts";
  version = "0.1";
  # src = fetchFromGitHub {
  #   owner = ""

  # }

  installPhase = "";
}
