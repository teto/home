final: prev: rec {

  # inherit (super.vimUtils.override {inherit (super) vim;}) buildVimPluginFrom2Nix;

  # generated = super.callPackage ./vim-plugins/generated.nix {
  #   inherit buildVimPluginFrom2Nix;
  # };

  # overrides = super.callPackage ./vim-plugins/overrides.nix {
  #   # inherit buildVimPluginFrom2Nix;
  # };

  # vimPlugins = (super.vimPlugins.extend( generated)).extend( overrides );
}
