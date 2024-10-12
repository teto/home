{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pass-tail";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "palortoff";
    repo = "pass-extension-tail";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RyPXW4Lgx6GdF9j+zEJqKRGxinDwPCmF9WXJ5yW4Pcc=";
  };

  dontBuild = true;
  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "A pass extension to avoid printing the password to the console";
    homepage = "https://github.com/dvogt23/pass-file";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.teto ];
    platforms = platforms.unix;
  };
})
