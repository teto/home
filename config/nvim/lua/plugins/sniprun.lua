local has_sniprun, sniprun = pcall(require, 'sniprun')

sniprun.setup({
	-- selected_interpreters = {'Python3_fifo'},        --" use those instead of the default for the current filetype
	-- repl_enable = {'Python3_fifo', 'R_original'},    --" enable REPL-like behavior for the given interpreters
	-- repl_disable = {},                               --" disable REPL-like behavior for the given interpreters
	interpreter_options = { --# interpreter-specific options, see docs / :SnipInfo <name>
		Bash_original = {
			use_on_filetypes = { 'nix' }, --# the 'use_on_filetypes' configuration key is
		},
		--# use the interpreter name as key
		--GFM_original = {
		--use_on_filetypes = {"markdown.pandoc"}    --# the 'use_on_filetypes' configuration key is
		--											--# available for every interpreter
		--},
		--Python3_original = {
		--	error_truncate = "auto"         --# Truncate runtime errors 'long', 'short' or 'auto'
		--									--# the hint is available for every interpreter
		--									--# but may not be always respected
		--}
	},
	-- possible values are 'none', 'single', 'double', or 'shadow'
	borders = 'single',
	--live_display = { "VirtualTextOk" }, --# display mode used in live_mode
	----# You can use the same keys to customize whether a sniprun producing
	----# no output should display nothing or '(no output)'
	--show_no_output = {
	--	"Classic",
	--	"TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
	--},
	--" you can combo different display modes as desired
	display = {
		'Classic', -- "display results in the command-line  area
		'VirtualTextOk', -- "display ok results as virtual text (multiline is shortened)
	},
})
vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', { silent = true })
vim.api.nvim_set_keymap(
	'n',
	'<leader>f',
	'<Plug>SnipRunOperator',
	{ silent = true, desc = 'Run code (pending operator)' }
)
vim.api.nvim_set_keymap('n', '<leader>ff', '<Plug>SnipRun', { silent = true, desc = 'Run some code' })

