with import <nixpkgs> {};

let
  prog = papis.overrideAttrs (oa: {

    src = ./.;

    postShellHook = ''
      export SOURCE_DATE_EPOCH=315532800
      export PATH="${my_nvim}/bin:$PATH"
      echo "importing a custom nvim ${my_nvim}"

    '';

  });

  my_nvim = genNeovim  [ papis ] {};
in
  prog
