{ pkgs, lib, ...} @ args:
let
in
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

    # hopefully the 'configure' variable will be improved to set $MYVIMRC
    # adopt neovim path etc
    # " let g:vimtex_compiler_latexmk.executable='${texliveEnv}/bin/latexmk'

    #  TODO I need to get the python env
    # I would need to get access to
    # let g:neomake_python_mypy_maker.exe =
    # let g:gutentags_ctags_executable_haskell = '${pkgs.haskell.lib.dontCheck pkgs.haskellPackages.hasktags}/bin/hasktags'
    # let g:deoplete#sources#clang#libclang_path='${pkgs.llvmPackages.libclang}'
    configure = pkgs.neovimDefaultConfig.configure;
    # {
    #     customRC = ''
    #     " here your custom configuration goes!
    #     " let $MYVIMRC=fnamemodify(expand('<sfile>'), ":p")


    #       " always see at least 10 lines
    #       set scrolloff=10

    #     " Failed to start language server: No such file or directory: 'pyls'
    #     " todo do the same for pyls/vimtex etc
    #     let g:vimtex_compiler_latexmk = {}
    #     " latexmk is not in combined.small/basic
    #     " vimtex won't let us setup paths to bibtex etc, we can do it in .latexmk ?

    #     let g:LanguageClient_serverCommands = {
    #          \ 'python': [ fnamemodify( g:python3_host_prog, ':p:h').'/pyls', '-vv', '--log-file' , '/tmp/lsp_python.log']
    #          \ , 'haskell': ['hie-wrapper', '--lsp', '-d', '--vomit', '--logfile', '/tmp/lsp_haskell.log' ]
    #          \ , 'cpp': ['${pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
    #          \ , 'c': ['${pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
    #          \ }

    #     " source $MYVIMRC

    #     autocmd BufReadPost *.pdf silent %!${pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
    #     ''
    #     ;

    #     # using this breaks my userplugins
    #     # plug.plugins = startPlugins;

    #     packages.myVimPackage =
    #     {
    #       # see examples below how to use custom packages
    #       # loaded on launch
    #       start = startPlugins;
    #       # manually loadable by calling `:packadd $plugin-name`
    #       opt = [ ];
    #     };
    #   };

}
