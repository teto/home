"" call LanguageClient_textDocument_hover
"" by default logs in /tmp/LanguageClient.log.
"let g:LanguageClient_autoStart=0 " Run :LanguageClientStart when disabled
"let g:LanguageClient_loadSettings = 1
"let g:LanguageClient_settingsPath=stdpath('config')."/settings.json"
"" pyls.configurationSources
"" my settings.json generates errors so remove it
"" let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."/nvim/settings.json"
"let g:LanguageClient_selectionUI='fzf'
"" or off / messages
"let g:LanguageClient_trace="verbose"
"let g:LanguageClient_loggingFile = "/tmp/lsp.log"
"let g:LanguageClient_serverStderr = '/tmp/lsp_err.log'
"" expected one of `OFF`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`
"let g:LanguageClient_debug = 1
"let g:LanguageClient_loggingLevel = 'INFO'
""Error" | "Warning" | "Info" | "Log"
"let g:LanguageClient_windowLogMessageLevel='Error'
"" to override default
"" let g:LanguageClient_hasSnippetSupport=1

"" let g:LanguageClient_documentHighlightDisplay =
"" call LanguageClient_setLoggingLevel('DEBUG')
""let g:LanguageClient_diagnosticsList="quickfix"
"" 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
"" let g:LanguageClient_loggingLevel='DEBUG'
""let g:LanguageClient_rootMarkers
"let g:LanguageClient_hoverPreview='Always'
"let g:LanguageClient_completionPreferTextEdit=1
"let g:LanguageClient_diagnosticsEnable=1
"let g:LanguageClient_useFloatingHover=1
"" else it erases grepper results
"let g:LanguageClient_diagnosticsList='Location'
"" see $RUNTIME/rplugin/python3/LanguageClient/wrapper.sh for logging
"" let g:LanguageClient_serverCommands.nix = ['nix-lsp']
"" del g:LanguageClient_serverCommands.cpp = ['cquery', '--log-file=/tmp/cq.log']
"silent! call remove(g:LanguageClient_serverCommands, 'cpp')
"silent! call remove(g:LanguageClient_serverCommands, 'c')

"" we use deoplete instead !!
"" there is also omnifunc ?
"set completefunc=LanguageClient#complete

"" this should be done only for filetypes supported by LanguageClient !!!
"set formatexpr=LanguageClient_textDocument_rangeFormatting()

"" todo provide a fallback if lsp not available
"" if get(g:, 'LanguageClient_loaded', 0)
"  " nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>

"nnoremap  ,h :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> ,d :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> ,r :call LanguageClient#textDocument_references()<CR>
"nnoremap <silent> ,s :call LanguageClient#textDocument_documentSymbol()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"" provides a list of everything possible
"command! FzfLSP call LanguageClient_contextMenu()

"" let it jump to
"nnoremap <C-LeftMouse> :call LanguageClient#textDocument_definition()<CR>

" endif
"function! GetHoverInfo()
"  " Only call hover if the cursor position changed.
"  "
"  " This is needed to prevent infinite loops, because hover info is displayed
"  " in a popup window via nvim_buf_set_lines() which puts the cursor into the
"  " popup window and back, which in turn calls CursorMoved again.
"  if mode() == 'n' && IsDifferentHoverLineFromLast()
"    let b:last_hover_line = line('.')
"    let b:last_hover_col = col('.')

"    call LanguageClient_textDocument_hover({'handle': v:true}, 'DoNothingHandler')
"    call LanguageClient_clearDocumentHighlight()
"    call LanguageClient_textDocument_documentHighlight({'handle': v:true}, 'DoNothingHandler')
"  endif
"endfunction

"augroup LanguageClient_config
"  autocmd!
"  autocmd CursorMoved * call GetHoverInfo()
"  autocmd CursorMovedI * call LanguageClient_clearDocumentHighlight()
"augroup end


