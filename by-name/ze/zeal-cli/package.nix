# python3 with argparse, zdg, sqlite3, pathlib and BeautifulSoup (bs4)
# Zeal (install the desired documentation sets from its GUI)
# Lynx web browser
{
  lib,
  stdenv,
  fetchFromGitLab,
  # , zeal
  # , lynx
  # , python3Packages
  # , sqlite
  # , writePython3
  xdg,
  beautifulsoup4,
  buildPythonApplication,
}:
let

  # buildPythonApplication could be used with format = "other";
  src = fetchFromGitLab {
    # domain = "gitlab.freedesktop.org";
    owner = "ivan-cukic";
    repo = "zeal-lynx-cli";
    rev = "1bf364389877fe87bd5c9d3e4177426304be2ddc";
    hash = "sha256-ob9wOwhSZK0psqHr/GcjiYHO0JRFL04zRAm3/QlPc3g=";
  };
  # writePython3 "zeal-cli" {
  #   # weird that it's not a function
  #   libraries = [ python3Packages.beautifulsoup4 ];
  #   } (builtins.readFile "${src}/zeal-cli")

in
buildPythonApplication {

  pname = "zeal-cli";
  version = "0.6.1.20230320";
  inherit src;

  format = "other";

  propagatedBuildInputs = [
    xdg
    beautifulsoup4
  ];

  # sourceRoot = "";
  buildPhase = "";

  installPhase = ''
    mkdir -p $out/bin
    cp zeal-cli $out/bin
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/ivan-cukic/zeal-lynx-cli";
    description = "A small script to show Zeal pages in Lynx";
    license = licenses.gpl2;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
  };
}
