{
  lib,
  fetchPypi,
  python3Packages,
}:

let
  dirhash = python3Packages.buildPythonPackage rec {
    pname = "dirhash";
    version = "0.5.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-5gdg8Ksuk12MsIiSPqLGSSOY3KQs7Hhd93iYX9TNU4Y=";
    };

    build-system = with python3Packages; [
      setuptools
      versioneer
    ];

    dependencies = with python3Packages; [
      scantree
    ];

    pythonImportsCheck = [ "dirhash" ];

    doCheck = false;
  };
in
python3Packages.buildPythonApplication rec {
  pname = "harbor";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m5GLmew4tOFtt+C3l9zr+Sv8i+nZuiKi0u1uu4/rON8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.4,<0.9.0' 'uv_build>=0.8.4'
  '';

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    dirhash
    fastapi
    filelock
    httpx
    jinja2
    litellm
    packaging
    pathspec
    platformdirs
    pydantic
    pyjwt
    python-dotenv
    pyyaml
    requests
    rich
    shortuuid
    supabase
    tenacity
    toml
    typer
    uvicorn
  ];

  pythonRelaxDeps = [
    "filelock"
    "platformdirs"
  ];

  pythonImportsCheck = [ "harbor" ];

  # Upstream tests exercise Docker, agent CLIs, cloud providers, and networked
  # benchmark flows that are not suitable for a sandboxed package build.
  doCheck = false;

  meta = {
    description = "Framework for evaluating and optimizing agents and models using sandboxed environments";
    homepage = "https://pypi.org/project/harbor/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "harbor";
  };
}
