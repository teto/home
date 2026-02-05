" syntax match Comment +\/\/.\+$+
setlocal fdm=syntax

" | fmt -w78
" todo reformat with jsonpretty ?
" autocmd BufReadPre *.jsonzlib %!pigz -dc "%" - 



  " :augroup gzip
  " :  autocmd!
  " :  autocmd BufReadPre,FileReadPre	*.gz set bin
  " :  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  " :  autocmd BufReadPost,FileReadPost	*.gz set nobin
  " :  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")
  " :  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  " :  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  " :  autocmd FileAppendPre		*.gz !gunzip <afile>
  " :  autocmd FileAppendPre		*.gz !mv <afile>:r <afile>
  " :  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  " :  autocmd FileAppendPost		*.gz !gzip <afile>:r
  " :augroup END

