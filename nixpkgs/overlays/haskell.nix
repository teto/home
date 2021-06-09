final: prev:
{
  # haskell = prev.haskell // {

  #   # to work around a stack bug (stack ghc is hardcoded)
  #   # compiler = prev.haskell.compiler // { ghc802 = prev.haskell.compiler.ghc844; };

  #   packageOverrides = hself: hold: with prev.haskell.lib; rec {
  #     # useful to fetch newer libraries with callHackage
  #     # gutenhasktags = dontCheck (hprev.callPackage ./pkgs/gutenhasktags {});

  #         # for newer nixpkgs (March 2020)
  #         # base-compat = doJailbreak (hold.base-compat);
  #         # time-compat = doJailbreak (hold.time-compat);

  #     # ihaskell = builtins.trace "overrideCABAL !!" overrideCabal (dontCheck hprev.ihaskell) ( drv: {
  #     #   executableToolDepends = [ prev.pkgs.jupyter ];
  #     #   executableHaskellDepends = [ prev.pkgs.jupyter ];
  #     # });

  #     ip = unmarkBroken (dontCheck hold.ip);
  #     bytebuild = unmarkBroken (dontCheck hold.bytebuild);
  #     byteslice = unmarkBroken hold.byteslice;
  #     # can be released on more recent nixplks
  #     # wide-word = doJailbreak (hold.wide-word);

  #     # for newer nixpkgs (March 2020)
  #     # base-compat = doJailbreak (hold.base-compat);
  #     # time-compat = doJailbreak (hold.time-compat);
  #     mptcp-pm = (overrideSrc hold.mptcp-pm {
  #       src = prev.fetchFromGitHub {
  #         owner = "teto";
  #         repo = "mptcp-pm";
  #         rev = "4087bd580dcb08919e8e3bc78ec3b25d42ee020d";
  #         sha256 = "sha256-MiXbj2G7XSRCcM0rnLrbO9L5ZFyh6Z3sPtnH+ddInI8=";
  #       };
  #     });
  #     netlink = (overrideSrc hold.netlink {
  #       # src = builtins.fetchGit {
  #       #   # url = https://github.com/ongy/netlink-hs;
  #       #   url = https://github.com/teto/netlink-hs;
  #       # };
  #       src = prev.fetchFromGitHub {
  #         owner = "teto";
  #         repo = "netlink-hs";
  #         rev = "090a48ebdbc35171529c7db1bd420d227c19b76d";
  #         sha256 = "sha256-qopa1ED4Bqk185b1AXZ32BG2s80SHDSkCODyoZfnft0=";
  #       };
  #     });
  #   };
  # };

}
