opts =
{
	auto_open = false,
	auto_close = true,
	cycle_results = true, -- cycle item list when reaching beginning or end of list
	position = 'bottom', -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	-- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	mode = 'workspace_diagnostics',
	multiline = true, -- render multi-line messages
	severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
	focus = true,
	fold_open = '▾', -- icon used for open folds
	fold_closed = '▸', -- icon used for closed folds
	group = true, -- group results by file
	padding = false, -- add an extra new line on top of the list
	pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
	keys = false,

	action_keys = { -- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = 'q', -- close the list
		cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
		refresh = 'r', -- manually refresh
		jump = { '<cr>', '<tab>', '<2-leftmouse>' }, -- jump to the diagnostic or open / close folds
		open_split = { '<c-x>' }, -- open buffer in new split
		open_vsplit = { '<c-v>' }, -- open buffer in new vsplit
		open_tab = { '<c-t>' }, -- open buffer in new tab
		jump_close = { 'o' }, -- jump to the diagnostic and close the list
		toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
		switch_severity = 's', -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
		toggle_preview = 'P', -- toggle auto_preview
		hover = 'K', -- opens a small popup with the full multiline message
		preview = 'p', -- preview the diagnostic location
		open_code_href = 'c', -- if present, open a URI with more information about the diagnostic error
		close_folds = { 'zM', 'zm' }, -- close all folds
		open_folds = { 'zR', 'zr' }, -- open all folds
		toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
		previous = 'k', -- previous item
		next = 'j', -- next item
		help = '?', -- help menu
	},
}
require('trouble').setup(opts)

vim.keymap.set('n', 'f2', function()
    -- vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN }
	 require("trouble").toggle()
	end)


