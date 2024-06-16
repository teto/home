let
  jupyter = import (builtins.fetchGit {
    url = "https://github.com/tweag/jupyterWith";
    rev = "";
  }) { };

  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    packages =
      p: with p; [
        numpy
        pandas
      ];
  };

  iHaskell = jupyter.kernels.iHaskellWith {
    name = "haskell";
    packages =
      p: with p; [
        hvega
        formatting
      ];
  };

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [
      iPython
      iHaskell
    ];
  };
in
# TODO use mkShell, run $ jupyter lab
jupyterEnvironment.env
