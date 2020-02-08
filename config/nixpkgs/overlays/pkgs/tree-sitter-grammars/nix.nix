{ stdenv
, language
, tree-sitter
, source ? "${tree-sitter.grammars}/${language}"
}:

stdenv.mkDerivation {

  name = "tree-sitter-${language}-matt";

  # sourceRoot = language;
  src = source;


  buildInputs = [ tree-sitter ];

  dontUnpack = true;
  configurePhase= ":";
  buildPhase = ''
    echo $src
    gcc -I$src/src/ -shared -o parser -Os $src/src/parser.c
  '';
  installPhase = ''
    mkdir $out
    cp parser $out/
  '';
}
