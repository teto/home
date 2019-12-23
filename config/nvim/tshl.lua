cquery = [[
(ERROR) @ErrorMsg

"break" @keyword
"case" @keyword
"continue" @keyword
"do" @keyword
"else" @keyword
"for" @keyword
"if" @keyword
"return" @keyword
"sizeof" @keyword
"switch" @keyword
"while" @keyword
"goto" @keyword

"const" @StorageClass
"static" @StorageClass
"struct" @StorageClass
"inline" @StorageClass
"enum" @StorageClass
"extern" @StorageClass
"typedef" @StorageClass
"union" @StorageClass

"#define" @PreProc
"#else" @PreProc
"#endif" @PreProc
"#if" @PreProc
"#ifdef" @PreProc
"#ifndef" @PreProc
"#include" @PreProc
(preproc_directive) @PreProc

(string_literal) @string
(system_lib_string) @string

(number_literal) @number
(char_literal) @string

(field_identifier) @property

((type_identifier) @Special.ee (eq? @Special.ee "Dictionary"))
(type_identifier) @UserType

(primitive_type) @type
(sized_type_specifier) @type

;((function_definition (storage_class_specifier) @funcclass declarator: (function_declarator (identifier) @StaticFunction))  (eq? @funcclass "static"))

((binary_expression left: (identifier) @WarningMsg.left right: (identifier) @WarningMsg.right) (eq? @WarningMsg.left @WarningMsg.right))

(comment) @comment

;(call_expression
;  function: (identifier) @function)
;(function_declarator
;  declarator: (identifier) @function)
;(preproc_function_def
;  name: (identifier) @function)
]]

c_highlight_bufs = c_highlight_bufs or {}

for _, highlighter in pairs(c_highlight_bufs) do
  highlighter:set_query(cquery)
end

local TSHighlighter = vim.treesitter.TSHighlighter

function chl_check_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  if c_highlight_bufs[bufnr] == nil then
    c_highlight_bufs[bufnr] = TSHighlighter.new(cquery)
  end
end

vim.api.nvim_command([[augroup TSCHL]])
vim.api.nvim_command([[au! FileType c lua chl_check_buf() ]])
vim.api.nvim_command([[augroup END ]])

if vim.api.nvim_buf_get_option(0,"ft") == "c" then
  chl_check_buf()
end