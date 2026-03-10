{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "batctl";
  version = "2026.3.11";

  src = fetchFromGitHub {
    owner = "Ooooze";
    repo = "batctl";
    rev = "426b117100bc915a1308dd73193bf32d68f3f026";
    sha256 = "sha256-fHjmodKF3gdSCp3AvsHP0WNxlxSWk3wVi1UqCUyZIs4=";
  };

  vendorHash = "sha256-irJksXupZGHzZ5vbFeI9laKi5+LyATc1lMxpMLLl69w=";

  subPackages = [ "cmd/batctl" ];

  meta = with lib; {
    description = "Battery charge threshold manager for Linux laptops";
    homepage = "https://github.com/Ooooze/batctl";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
