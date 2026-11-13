{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python3Packages,
}:

buildHomeAssistantComponent rec {
  owner = "hekmon";
  domain = "rtetempo";
  version = "1.5.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "rtetempo";
    tag = "v${version}";
    hash = "sha256-TA0IR/tPsmaQNJ9tixQe0KqqWAIq+mypmMR9mVB0dek=";
  };

  dependencies = [
    python3Packages.requests-oauthlib
  ];

  meta = {
    description = "RTE Tempo days calendar and sensors for Home Assistant";
    homepage = "https://github.com/hekmon/rtetempo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
