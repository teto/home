{ pkgs, lib}:
{
    enable = true;
    withPython3 = true;
    withPython = false;
    withRuby = true; # for vim-rfc/GhDashboard etc.

    # most likely generated by vimutils
    # vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };
    # configure = {
    #   customRC=''

    #   '';

    #   # works but puts the config in store
    #   # might be best in config/init.vim
    #   # exec -a "$0" "/nix/store/9cscr6bwvpzglnbdfrdvnf24zmk6kkm3-neovim/bin/.nvim-wrapped"  -u /nix/store/smivig5i5b605mm1z2ny9nxzj6g8qn0k-vimrc "${extraFlagsArray[@]}" "$@"
    #   packages.myVimPackage = with pkgs.vimPlugins; {
    #       # see examples below how to use custom packages
    #       start = [ fugitive ];
    #       opt = [ ];
    #     };
    # };

    # hopefully these can be added automatically once I use vim_configurable
    extraPython3Packages = with pkgs.python3Packages;[
      pandas jedi urllib3
    ]
      ++ lib.optionals ( pkgs ? python-language-server) [ pkgs.python-language-server ]
      ;
  #      configure = {
  #        customRC = ''
  #         # here your custom configuration goes!
  #        '';
  #        # packages.myVimPackage = with pkgs.vimPlugins; {
  #        #   # see examples below how to use custom packages
  #        #   # loaded on launch
  #        #   start = [ fugitive ];
  #        #   # manually loadable by calling `:packadd $plugin-name`
  #        #   opt = [ ];
  #        # };
  #      };
  #    }; in

    # extraConfig = ''
    #   " TODO set different paths accordingly, to language server especially
    #   let g:clangd_binary = '${pkgs.clang}'
    #   # let g:pyls = '${pkgs.clang}'
    #   '' ;

}
