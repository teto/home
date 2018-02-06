self: super:
{
  neovim-local = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
      withPython = false;
      withPython3 = true; # pour les tests ?
      withRuby = true; # pour les tests ?
      extraPython3Packages = with self.python3Packages;[ pandas python jedi]
      ++ super.stdenv.lib.optionals ( self.pkgs ? python-language-server) [ self.pkgs.python-language-server ]
      ;
      # todo generate a file with the path to python-language-server ?
      # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  src = super.lib.cleanSource ~/neovim;
      meta.priority=0;
  });

  # neovim-master = (self.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-master";
	  # version = "nightly";
  #     src = fetchGitHashless {
  #       rev = "master";
  #       url = "git@github.com:neovim/neovim.git";
  #     # src = super.fetchFromGitHub {
  #     #   owner = "neovim";
  #     #   repo = "neovim";
  #     #   rev = "nightly";
  #     #   sha256 = "1a85l83akqr8zjrhl8y8axsjg71g7c8kh4177qdsyfmjkj6siq4c";
  #     };

  #     meta.priority=0;
	# })) or null;

  }
