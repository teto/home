cp $(nix-build -A tree-sitter.builtGrammars.c ~/nixpkgs)/parser config/nvim/parser/c.so

# nix-build -A tree-sitter.builtGrammars.lua ~/nixpkgs

