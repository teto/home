self: prev:
rec {

  lua = prev.lua.override {


  #     # TODO use my fork
  #     nvim-client  = luaprev.nvim-client.overrideAttrs (oa: {
  #       src = /home/teto/lua-client;
  #       # src = prev.fetchFromGitHub {
  #       #   repo = "lua-client";
  #       #   owner = "teto";
  #       #   rev = "ffe21016d4ac2de810cc89a4f686fd72065214c0";
  #       #   sha256= "";

  #       # };
  #     });

    # packageOverrides = luaself: luaprev: {

    #   luarocks-nix = luaprev.luarocks-nix.overrideAttrs(oa: {
    #     pname = "luarocks-local";
    #     src = /home/teto/luarocks;
    #     # src = builtins.fetchGit {
    #     #   url = https://github.com/teto/luarocks/;
    #     #   ref = "nix";
    #     # };
    #   });

    #   # prev.lib.traceValSeq 
    #   cqueues = ( luaprev.cqueues.override({
    #     # name = "matt";
    #     # pname = "matt";
    #     disabled = false;
    #   }));
    # };

  };

  # lua51Packages = lua5_1.pkgs;
  luaPackages = lua.pkgs;
}
