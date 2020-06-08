with import <nixpkgs> {};

let
  # black
  myPythonEnv = python3.withPackages(ps: with ps; [
    chardet  # encoding detector
    certifi
    pandas
  ]);
in
mkShell {

  name = "platform";
  buildInputs = [
    black  # python linter
    jq docker-compose
    myPythonEnv
    pipenv

    python-language-server
  ];

  #     export DOCKER_HOST=
  shellHook = ''
    export PYTHONPATH=${myPythonEnv}/${myPythonEnv.sitePackages}
  '';
}
