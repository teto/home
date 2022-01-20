{ config, lib, pkgs,  ... }:
{

  programs.neovim = {

    enable = false;

	# source /home/teto/.config/nvim/init.vim
    configure = pkgs.neovimConfigure // {
      customRC = (pkgs.neovimConfigure.customRC  or "") + ''
        let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
        let g:fzf_nvim_statusline = 0 " disable statusline overwriting
      '';

    };

    runtime."ftplugin/bzl.vim".text = ''
      setlocal expandtab
    '';

    runtime."ftplugin/c.vim".text = ''
      " otherwise vim defaults to ccomplete#Complete
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';


    # cp $(nix-build -A tree-sitter.builtGrammars."$lang" ~/nixpkgs)/parser config/nvim/parser/${lang}.so
    # runtime."parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.c}/parser";
    # runtime."parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.bash}/parser";
  };

# programs = {
#     neovim = {
#       enable = true;
#       defaultEditor = true;
#       configure = {
#         packages.myVimPackage = with pkgs.vimPlugins; {
#           start = [
#             vim-airline
#             vim-airline-themes
#             vim-airline-clock
#             # FixCursorHold missing
#             # Fern missing
#             # nerdfont
#             # fern-renderer-nerdfont
#             # fern-git-status
#             # glyph-palette
#             direnv-vim
#             vim-fugitive
#             vim-gitgutter
#             vim-polyglot
#             coc-nvim
#             # coc-rust-analyzer
#             # coc-clangd
#             coc-java
#             coc-vimtex
#             vimtex
#             vim-grammarous
#             pear-tree
#             tagbar
#             vim-startify
#             vim-crates
#             # rust-doc missing
#           ];

#           opt = [
#             onedark-vim
#           ];
#         };      
        
#         # Missing the fern configs
#         customRC = ''
#           syntax on
#           set termguicolors
#           packadd! onedark-vim
#           colorscheme onedark
#           filetype plugin indent on
#           set encoding=utf-8
#           set title
#           set number relativenumber
#           set hidden

#           augroup numbertoggle
#             autocmd!
#             autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
#             autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
#           augroup END

#           au TermOpen * setlocal nonumber norelativenumber
#           au BufEnter * if &buftype == 'terminal' | :startinsert | endif

#                 let g:vimtex_compiler_latexmk = {
#                   \ 'options' : [
#                   \    '-shell-escape',
#                   \    '-verbose',
#                   \    '-file-line-error',
#                   \    '-synctex=1',
#                   \    '-interaction=nonstopmode',
#                   \ ],
#                   \}

#           let g:vimtex_view_method = 'zathura'

#           let g:airline_powerline_fonts = 1
#                 let g:airline_theme='onedark'
#                 let g:airline_detect_modified=1
#                 let g:airline_detect_crypt=1
#                 let g:airline_detect_paste=1
#                 let g:airline_detect_spell=1
#                 let g:airline_detect_spelllang=1
#                 let g:airline_detect_iminsert=1
#                 let g:airline_inactive_collapse=1
#                 let g:airline#extensions#tabline#enabled = 1
#                 let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
#                 let g:airline#extensions#clock#format = '%a %d/%m/%Y %H:%M'

#           if has('nvim')
#             autocmd BufRead Cargo.toml call crates#toggle()
#           endif

#           nmap <silent> <Leader>t :TagbarToggle<CR>
#         '';
#       };
#     };
#   };
}
