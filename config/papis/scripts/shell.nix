# https://papis.readthedocs.io/en/latest/importing.html#importing-from-zotero-sqlite-file
nix-shell -p 'python3.withPackages(ps: with ps;[ sqlite pyyaml dateutil ])' ~/nixpkgs
