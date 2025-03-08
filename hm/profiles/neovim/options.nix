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
  };
}
