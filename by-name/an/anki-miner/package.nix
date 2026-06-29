{
  lib,
  fetchFromGitHub,
  ffmpeg,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "anki-miner";
  version = "unstable-2026-06-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teto";
    repo = "anki_miner";
    rev = "1c93436aa92b2e7742812068ce6685f84d58f0d0";
    hash = "sha256-DeolxegHjMybUgYyL0pMIy/SGMsm2S5wJ/NTeV8IDAg=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    fugashi
    gtts
    packaging
    psutil
    pyqt6
    pysubs2
    requests
    unidic-lite
    yt-dlp
  ];

  pythonRelaxDeps = [ "requests" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  pythonImportsCheck = [ "anki_miner" ];

  # Upstream tests include GUI, network, YouTube, and AnkiConnect integration
  # coverage that is not suitable for a sandboxed package build.
  doCheck = false;

  meta = {
    description = "Automated Japanese vocabulary mining from media with Anki integration";
    homepage = "https://github.com/teto/anki_miner";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "anki_miner_gui";
  };
}
