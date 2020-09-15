function! health#lsp#check() abort

	" call health#report_error('key_backspace (kbs) terminfo entry: ')
	call health#report_info('testing debug_lsp !')
	lua require 'debug_lsp'.check_health()
endfunc
