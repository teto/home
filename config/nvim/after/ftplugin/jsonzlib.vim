" todo reformat with jsonpretty ?
" autocmd BufReadPre *.jsonzlib %!pigz -dc "%" - | jq '.'

" %!jq '.'
