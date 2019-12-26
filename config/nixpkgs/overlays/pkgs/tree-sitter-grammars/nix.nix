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
    gcc -I$src/src/ -shared -o shared.so -Os $src/src/parser.c
  '';
  installPhase = ''
    mkdir $out
    cp shared.so $out/
  '';
}
