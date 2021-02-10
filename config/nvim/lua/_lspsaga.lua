-- lspsaga {{{
local saga = require 'lspsaga'
local saga_opts = {
  -- 1: thin border | 2: rounded border | 3: thick border
  border_style = 2,
  -- max_hover_width = 2,
   error_sign = '✘',
	warn_sign = '！',
	hint_sign = 'H',
	infor_sign = 'I',
	code_action_icon = ' ',
	max_diag_msg_width = 200,
	max_finder_preview_lines = 10,
-- finder_definition_icon = '  ',
-- finder_reference_icon = '  ',
-- definition_preview_icon = '  '
}

saga.init_lsp_saga(saga_opts)
--}}}

