{
  luaRcBlocks = {
    appearance = ''
      -- draw a line on 80th column
      vim.o.colorcolumn='80,100'
    '';

    # hi MsgSeparator ctermbg=black ctermfg=white
    # TODO equivalent of       set fillchars+=
    foldBlock = ''
      vim.o.fillchars='foldopen:▾,foldclose:▸,msgsep:‾'
      vim.o.foldcolumn='auto:2'
    '';
    # dealingwithpdf= ''
    #   " Read-only pdf through pdftotext / arf kinda fails silently on CJK documents
    #   " autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

    #   " convert all kinds of files (but pdf) to plain text
    #   autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
    # '';

    # sessionoptions = ''
    #   set sessionoptions-=terminal
    #   set sessionoptions-=help
    # '';
  };
}
