# devShell for some of my experiments,
# most likely need my python overlay
{

  mkShell,
  python3,
  just,
}:
mkShell {

  # dont use the top-level 'jupyter' as it needs to be overriden with proper kernel-definitions
  # pkgs.jupyter.override({ definitions = kernel-definitions; })
  buildInputs =
    let
      # I need an env else I hit https://github.com/NixOS/nixpkgs/issues/255923, aka
      # the main python can't find notebook files.
      pyEnv = python3.withPackages (ps: [
        ps.gguf
        ps.notebook
        ps.jupyter-console
        ps.transformers # for https://huggingface.co/learn/smol-course/unit1/2
        ps.trl # for https://huggingface.co/learn/smol-course/unit1/3?first_fine_tune=python
        ps.trackio
      ]);
    in

    [
      # allKernels
      just
      pyEnv
      # -notebook

      # ghcEnv needs to be in PATH else ihaskell can't find it
      # ihaskell needs to be wrapped ?
      # ghcEnv

      # jupyterEnvironment
      # jup-console

      # this gets jupyter's python in PATH
      # run python-Python-data-env
      # iPythonKernel.runtimePackages
    ];
  shellHook = "";

}
