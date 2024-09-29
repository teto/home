
        -- Pour le rappel
        -- <localleader>ll pour la compilation continue du pdf
        -- <localleader>lv pour la preview du pdf
        -- see https://github.com/lervag/vimtex/issues/1058
        -- let g:vimtex_log_ignore 
        -- taken from https://castel.dev/post/lecture-notes-1/
        vim.g.tex_conceal='abdmg'
        vim.g.vimtex_log_verbose=1
        vim.g.vimtex_quickfix_open_on_warning = 1
        vim.g.vimtex_view_automatic=1
        vim.g.vimtex_view_enabled=1
        -- was only necessary with vimtex lazy loaded
        -- let g:vimtex_toc_config={}
        -- let g:vimtex_complete_img_use_tail=1
        -- autoindent can slow down vim quite a bit
        -- to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_compiler_enabled=1
        vim.g.vimtex_compiler_progname='nvr'
        vim.g.vimtex_quickfix_method="latexlog"
        -- 1=> opened automatically and becomes active (2=> inactive)
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_format_enabled = 0
        vim.g.vimtex_complete_recursive_bib = 0
        vim.g.vimtex_complete_close_braces = 0
        vim.g.vimtex_fold_enabled = 0
        vim.g.vimtex_view_use_temp_files=1 -- to prevent zathura from flickering
        -- let g:vimtex_syntax_minted = [ { 'lang' : 'json', \ }]

        -- shell-escape is mandatory for minted
        -- check that '-file-line-error' is properly removed with pplatex
        -- executable The name/path to the latexmk executable. 
