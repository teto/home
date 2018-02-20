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
        " let $MYVIMRC=fnamemodify(expand('<sfile>'), ":p")
 
        source $MYVIMRC

        " Failed to start language server: No such file or directory: 'pyls'
        " todo do the same for pyls/vimtex etc
        let g:vimtex_compiler_latexmk = {}
        " latexmk is not in combined.small/basic
        let g:vimtex_compiler_latexmk.executable='${pkgs.texlive.combined.scheme-medium}/bin/latexmk'
        let g:vimtex_compiler_latexmk.executable='${pkgs.texlive.combined.scheme-medium}/bin/latexmk'

        " Todo add pyls to neovim deps ?
        " tjdevries lsp {{{
        let g:langserver_executables = {
            \ 'go': {
            \ 'name': 'sourcegraph/langserver-go',
            \ 'cmd': ['langserver-go', '-trace', '-logfile', expand('~/Desktop/langserver-go.log')],
            \ },
            \ 'c': {
            \ 'name': 'clangd',
            \ 'cmd': ['clangd', ],
            \ },
            \ 'python': {
            \ 'name': 'pyls',
            \ 'cmd': ['pyls', '--log-file' , expand('~/lsp_python.log')],
            \ },
              \ }
        " }}}
        " autozimu's lsp {{{
        " call LanguageClient_textDocument_hover
        " by default logs in /tmp/LanguageClient.log.
        let g:LanguageClient_autoStart=1 " Run :LanguageClientStart when disabled

        let g:LanguageClient_selectionUI='fzf'
        " let g:LanguageClient_trace="verbose"
        " call LanguageClient_setLoggingLevel('DEBUG')
        "let g:LanguageClient_diagnosticsList="quickfix"

        " \ 'c': ['clangd', ],
        let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ 'cpp': ['clangd', ],
            \ 'python': ['pyls', '--log-file' , expand('~/lsp_python.log')]
            \ }

        " todo provide a fallback if lsp not available
        nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
        " nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

        "}}}
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
