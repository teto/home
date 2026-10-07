{ fishPlugins, fetchFromGitHub }:
fishPlugins.tide.overrideAttrs {

  # https://github.com/plttn/tide
  src = fetchFromGitHub {
    owner = "plttn";
    repo = "tide";
    rev = "f4349f5227f2fce1f16fc0a9c35cfe4b7f815578";
    hash = "sha256-KDxGKBWkzOEwMYU1nYFnyA+RxczArpoEBI1mav19WUM=";
  };
}
