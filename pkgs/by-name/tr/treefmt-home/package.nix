{ treefmt-nix, pkgs }:
treefmt-nix.lib.mkWrapper pkgs {
  # Used to find the project root
  projectRootFile = ".git/config";

  # TODO useofficial
  # programs.fourmolu.enable = true;
  programs.nixfmt = {
    enable = true;
    # package = myPkgs.nixfmt;
  };
  programs.stylua.enable = true;
  programs.just.enable = true;
  programs.shfmt.enable = true;

  # supports jsonc I think
  # programs.jsonfmt.enable = true;
  # programs.hujsonfmt.enable = true;

  # formatjson5 supports comments but it is too violent, it removes quotes around keys
  # programs.formatjson5 = {
  #   enable = true;
  #   includes = [ "*.jsonc" ];
  # };

  settings.global.excludes = [
    "*.org"
    "*.wiki"
    "nixpkgs/secrets.nix" # all git-crypt files ?
    "config/bash/jj.sh" # it has zsh oddities not supported by shfmt
    "config/nvim/lua/teto/secrets.lua"
  ];

}
