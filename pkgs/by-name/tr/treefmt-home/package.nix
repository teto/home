{ treefmt-nix, pkgs }:
treefmt-nix.lib.mkWrapper pkgs {
  # Used to find the project root
  projectRootFile = ".git/config";

  # TODO useofficial 
  programs.fourmolu.enable = true;
  programs.nixfmt-rfc-style = {
    enable = true;
    # package = myPkgs.nixfmt;
  };
  programs.stylua.enable = true;
  programs.just.enable = true;
  programs.shfmt.enable = true;

  settings.global.excludes = [
    "*.org"
    "*.wiki"
    "nixpkgs/secrets.nix" # all git-crypt files ?
  ];

}
