{ pkgs, lib, ...} @ args:
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
    extraPython3Packages = ps: with ps; [
      pandas
      jedi
      urllib3 
      # pygments # for pygmentize and minted in latex
      pyls-mypy # on le desactive sinon il genere des
      python-language-server
      pycodestyle
    ]
      # ++ lib.optionals ( pkgs ? pyls-mypy) [ pyls-mypy ]
    ;

    # hopefully the 'configure' variable will be improved to set $MYVIMRC
    # adopt neovim path etc
    # " let g:vimtex_compiler_latexmk.executable='${texliveEnv}/bin/latexmk'

    #  TODO I need to get the python env
    # I would need to get access to 
    # let g:neomake_python_mypy_maker.exe = 
    configure = {
        customRC = ''
        " here your custom configuration goes!
        " hopefully we can soon do without it
          let $MYVIMRC='/home/teto/.config/nvim/init.vim'
          " or alternatively
        " expand(‘<sfile>’)
        " let $MYVIMRC=fnamemodify(expand('<sfile>'), ":p")


        " Failed to start language server: No such file or directory: 'pyls'
        " todo do the same for pyls/vimtex etc
        let g:vimtex_compiler_latexmk = {}
        " latexmk is not in combined.small/basic
        " vimtex won't let us setup paths to bibtex etc, we can do it in .latexmk ?

        let g:deoplete#sources#clang#libclang_path='${pkgs.llvmPackages.libclang}'

        let g:gutentags_ctags_executable_haskell = '${pkgs.haskell.lib.dontCheck pkgs.haskellPackages.hasktags}/bin/hasktags'


        let g:LanguageClient_serverCommands = {
             \ 'python': [ fnamemodify( g:python3_host_prog, ':p:h').'/pyls', '--log-file' , expand('~/lsp_python.log')]
             \ , 'haskell': ['hie', '--lsp', '-d', '--logfile', '/tmp/lsp_haskell.log' ]
             \ , 'cpp': ['${pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ , 'c': ['${pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ }

        source $MYVIMRC
        '';

        # packages.myVimPackage
        plug.plugins = with pkgs.vimPlugins; 
        [

            fugitive
            vimtex
            LanguageClient-neovim
            vim-signify
            vim-startify
            vim-scriptease
            vim-grepper
            vim-nix
            vim-obsession
            deoplete-khard
        ];
        # {
        #   # see examples below how to use custom packages
        #   # loaded on launch
        #   start = [
        #     fugitive
        #     vimtex
        #     LanguageClient-neovim
        #     vim-signify
        #     vim-startify
        #     vim-scriptease
        #     vim-grepper
        #     vim-nix
        #     # vim-obsession
        #   ];
        #   # manually loadable by calling `:packadd $plugin-name`
        #   opt = [ ];
        # };
      };

    # extraConfig = ''
    #   " TODO set different paths accordingly, to language server especially
    #   let g:clangd_binary = '${pkgs.clang}'
    #   # let g:pyls = '${pkgs.clang}'
    #   '' ;
}
