# TODO pin
with import <nixpkgs> {};

let

  # myPythonEnv = poetry2nix.mkPoetryEnv {
  #   projectDir = ./.;
  # };

  myPythonEnv = python37.withPackages(ps: with ps; [
    chardet  # encoding detector
    certifi
    locustio  # disable checks for now / locustio not supported for 3.8
    pandas
    poetry  # temp to test
  ]);

  nixpkgsRev = "3223730c3d202f34f3833e37caeab875c85621a6";  # 1.25.0
  nixpkgsSig = "05z9lfm3sz8c4ffah5xhc1gcv52b7dhkzmby4lmla7dpq4zsj3gm";
  old = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${nixpkgsRev}.tar.gz";
    sha256 = nixpkgsSig;
  }) {};

in
mkShell {

  name = "platform";
  buildInputs = [
    black  # python linter
    jq
    old.docker-compose
    myPythonEnv
    pipenv

    python-language-server

    # for testing
    httperf
    apacheHttpd  # ab binary
  ];

  shellHook = ''
    export PYTHONPATH=${myPythonEnv}/${myPythonEnv.sitePackages}
    # Use Docker Buildkit
    export COMPOSE_DOCKER_CLI_BUILD=1
    export DOCKER_BUILDKIT=1
    source please-env.bash


  '';
}
