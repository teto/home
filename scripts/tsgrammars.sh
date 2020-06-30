#!/bin/sh

# TODO add nix/lua
for lang in "c" "bash" "json" ; do
	cp $(nix-build -A tree-sitter.builtGrammars."$lang" ~/nixpkgs)/parser config/nvim/parser/${lang}.so
done

# nix-build -A tree-sitter.builtGrammars.lua ~/nixpkgs

