{ pkgs
, lib
, flakeInputs
, ...
}:

let

  inherit (pkgs.tetoLib) luaPlugin genBlockLua;

  pluginsMap = pkgs.callPackage ./neovim/plugins.nix {};
  # taken from the official flake
  # must be an unwrapped version
  # myNeovimUnwrapped = pkgs.neovim-unwrapped.override({ libuv = libuv_147;});
  # myNeovimUnwrapped = flakeInputs.neovim.packages."${pkgs.system}".neovim.overrideAttrs(oa: {
  #   patches = builtins.head oa.patches;
  # });
  # lua =   myNeovimUnwrapped.lua;

  # " , { 'tag': 'v3.12.0' }
  # Plug 'Olical/aniseed' " dependency of ?
  # Plug 'bakpakin/fennel.vim'

  rawPlugins = 
       pluginsMap.basePlugins
    ++ pluginsMap.luaPlugins
    ++ pluginsMap.colorschemePlugins
    ++ pluginsMap.filetypePlugins
  ;

in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # custom options
    # fennel.enable = false;
    # teal.enable = false;
    orgmode.enable = true;
    autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    # package = myNeovimUnwrapped;

    # source doesn't like `stdpath('config').'`
    # todo should use mkBefore ${config.programs.neovim.generatedInitrc}
    # source $XDG_CONFIG_HOME/nvim/init.manual.vim
    # extraConfig = let 
    # in ''
    #   let mapleader = " "
    #   let maplocalleader = ","
    # ''
    # # concatStrings = builtins.concatStringsSep "";
    # + (lib.strings.concatStrings (
    # lib.mapAttrsToList genBlockViml vimlRcBlocks
    # ))
    # ;


     extraLuaConfig = lib.mkBefore (lib.strings.concatStrings (
        lib.mapAttrsToList genBlockLua (import ./neovim/options.nix).luaRcBlocks
      ))
     ;

    # TODO this should disappear in the future
    # extraLuaPackages = ps: ps.rest-nvim.propagatedBuildInputs ;
    # [
    #   ps.mpack
    # ];

    extraPackages = with pkgs; [
      # emacs # for orgmode-babel
      nil # a nix lsp, can be debugged with NIL_LOG_PATH and NIL_LOG=nil=debug
      # nixd # another nix LSP (broken because of nix security issue)
      shellcheck
      sumneko-lua-language-server
    ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };
}
