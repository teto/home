{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mariadb-ai-plugins";
  version = "26.11.0";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "ai-plugins";
    rev = "ddb63798323cb63a914703255754fe5edea9ce3a";
    hash = "sha256-1kMuZIkUFTf4BMNlMDUylR9MNmrY56aBokclStuaoRQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -d "$out/share/mariadb-ai-plugins"
    cp -a claude codex hermes opencode pi "$out/share/mariadb-ai-plugins/"
    install -m644 README.md LICENSE "$out/share/mariadb-ai-plugins/"
    runHook postInstall
  '';

  meta = {
    description = "MariaDB skills and MCP server plugins for AI coding agents";
    homepage = "https://github.com/mariadb-corporation/ai-plugins";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.unix;
  };
}
