{ pkgs, lib, texliveEnv, ...} @ args:
{
    enable = true;
    withPython3 = true;
    withPython = false;
    withRuby = true; # for vim-rfc/GhDashboard etc.

    #   # works but puts the config in store
    #   # might be best in config/init.vim
    #   packages.myVimPackage = with pkgs.vimPlugins; {
    #       # see examples below how to use custom packages
    #       start = [ fugitive ];
    #       opt = [ ];
    #     };
    # };

    # hopefully these can be added automatically once I use vim_configurable
    extraPython3Packages = with pkgs.python3Packages;[
      pandas jedi urllib3  pyls-mypy 
    ]
      # ++ lib.optionals ( pkgs ? pyls-mypy) [ pyls-mypy ]
    ;

    # hopefully the 'configure' variable will be improved to set $MYVIMRC
    # adopt neovim path etc
    # " let g:vimtex_compiler_latexmk.executable='${texliveEnv}/bin/latexmk'
    configure = {
        customRC = ''
        " here your custom configuration goes!
        " hopefully we can soon do without it
          let $MYVIMRC='/home/teto/.config/nvim/init.vim'
          " or alternatively
        " expand(‘<sfile>’)
        " let $MYVIMRC=fnamemodify(expand('<sfile>'), ":p")

        source $MYVIMRC

        " Failed to start language server: No such file or directory: 'pyls'
        " todo do the same for pyls/vimtex etc
        let g:vimtex_compiler_latexmk = {}
        " latexmk is not in combined.small/basic
        " vimtex won't let us setup paths to bibtex etc, we can do it in .latexmk ?

        let g:deoplete#sources#clang#libclang_path='${pkgs.llvmPackages.libclang}'

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
