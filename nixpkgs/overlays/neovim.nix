self: super:
{
  # neovim-local = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-local";
  #     withPython = false;
  #     withPython3 = true; # pour les tests ?
  #     withRuby = true; # pour les tests ?
  #     extraPython3Packages = with self.python3Packages;[ pandas python jedi]
  #     ++ super.stdenv.lib.optionals ( self.pkgs ? python-language-server) [ self.pkgs.python-language-server ]
  #     ;
  #     # todo generate a file with the path to python-language-server ?
  #     # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  # src = super.lib.cleanSource ~/neovim;
  #     meta.priority=0;
  # });

  # neovim-unwrapped = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  # # name = "neovim";
	  # # version = "nightly";
  #     # src = self.fetchGitHashless {
  #     #   rev = "master";
  #     #   url = "git@github.com:neovim/neovim.git";
  #     src = super.fetchFromGitHub {
  #       owner = "neovim";
  #       repo = "neovim";
  #       rev = "674cb2afde0d82557c8e3afdf706cd6f75195fa5";
  #       sha256 = "13cyfvhxjfc3h50vhfdfifi2zxm15w0mda67nxvlj6ksvcjy4020";
  #     };

  #     meta.priority=1;
  #   });
    # or null;

  }
