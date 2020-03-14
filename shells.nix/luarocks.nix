with import <nixpkgs> {};

let
  # luarocks-dev = 
      # luarocks-nix-dev = luaprev.luarocks-nix.overrideAttrs(oa: {
      #   pname = "luarocks-local";
      #   src = /home/teto/luarocks;
      #   # src = builtins.fetchGit {
      #   #   url = https://github.com/teto/luarocks/;
      #   #   ref = "nix";
      #   # };
      # });

in
  luaPackages.luarocks-nix-dev
