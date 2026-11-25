{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeModules.neovim

    flakeSelf.homeProfiles.teto-aliases
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.tmux
  ];

  programs.fzf = {
    enableFzfGit = true;
  };

  home.packages = [
    pkgs.systemctl-tui

    pkgs.lazydocker
    pkgs.ripgrep
    pkgs.just
  ];

  programs.tmux = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      js = {
        # command "nh" ou bien nixos- ?
        # name = "tetos-sw";
        setCursor = true;
        expansion = ''
          nh os switch ~/home -- --keep-going --override-input nixpkgs ~/nixpkgs \
            --override-input hm ~/hm #% --option builders "$TETOS_BUILDER_JEDHA" -j0 '';

      };
    };
  };

  programs.git = {
    enable = true;
    includes = [

      { path = config.xdg.configHome + "/git/manual.gitconfig"; }
    ];

    package = pkgs.gitFull; # to get send-email

    settings = {
      # user = {
      #   email = lib.mkForce "886074+teto@users.noreply.github.com";
      # };
      user = {
        # mkForce due to nova
        name = "Matthieu C.";
        email = lib.mkForce "886074+teto@users.noreply.github.com";
      };

      # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
      credential.helper = "store";
    };

  };

  # so it can be easily referenced from llama-bench
  # xdg.configFile."llama.cpp/config.ini".source = ./services/spark-presets.ini;

  programs.flyline.enable = true;

  programs.neovim = {

    enableRocks = true;
    highlightOnYank = true;
    enableFzfLua = true;
    # enableBlink = true;

    initLua = ''
      require('init-manual')
    '';
  };
}
