{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pandas,
  huggingface-hub,
  gradio,
  numpy,
  pillow,
  orjson,
  pydub,
  plotly,
  tomli,

}:

buildPythonPackage rec {
  pname = "trackio";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "trackio";
    rev = "trackio@${version}";
    sha256 = "sha256-ky/QArWvcqfxi7RCOAoAhymGNmsQRJI7d4gcP4xoIb8=";
  };
  pyproject = true;
  # build-system = [ setuptools ]
  build-system = [
    hatchling
  ];

  propagatedBuildInputs = [
    pandas
    huggingface-hub
    gradio
    numpy
    pillow # - pillow<12.0.0 not satisfied by version 12.1.0
    orjson
    pydub
    plotly
    tomli
  ];

  pythonRelaxDeps = [
    "pillow"
  ];
  doCheck = false;

  meta = with lib; {
    description = "Trackio - A Python library for tracking and analytics";
    homepage = "https://github.com/gradio-app/trackio";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
