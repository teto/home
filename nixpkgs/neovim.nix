{ pkgs, lib}:
{
    enable = true;
    withPython3 = true;
    withPython = false;
    withRuby = true; # for vim-rfc/GhDashboard etc.

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

    # hopefully the 'configure' variable will be improved to set $MYVIMRC
    # adopt neovim path etc
    configure = {
        customRC = ''
        " here your custom configuration goes!
        " hopefully we can soon do without it
          let $MYVIMRC='/home/teto/.config/nvim/init.vim'
          " or alternatively
        " expand(‘<sfile>’)
          let $MYVIMRC=/home/teto/.config/nvim/init.vim
        " let $MYVIMRC=fnamemodify(expand('<sfile>'), ":p")
 
        source $MYVIMRC

        " todo do the same for pyls/vimtex etc
        let g:vimtex_compiler_latexmk.executable=${pkgs.texlive.combined.scheme-basic}
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          # see examples below how to use custom packages
          # loaded on launch
          start = [ fugitive vimtex ];
          # manually loadable by calling `:packadd $plugin-name`
          opt = [ ];
        };
      };

    # extraConfig = ''
    #   " TODO set different paths accordingly, to language server especially
    #   let g:clangd_binary = '${pkgs.clang}'
    #   # let g:pyls = '${pkgs.clang}'
    #   '' ;
}
