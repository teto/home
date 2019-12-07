
nvim -V3 to see terminal

# Tree-sitter

nix run nixpkgs.tree-sitter nixpkgs.nodePackages.node-gyp nixpkgs.python27 nixpkgs.nodejs

:h lua-treesitter
    vim.treesitter.add_language("/path/to/c_parser.so", "c")
vim.treesitter.add_language("/home/teto/tree-sitter-c/build/Release/tree_sitter_c_binding.node", "c")
undefined symbol: node_module_register
