with import ./. {};
  neovim.override {
    extraPython3Packages = (ps: []);
    withNodeJs = true;
    withRuby = false;
    vimAlias = true;
    viAlias = true;
  }
