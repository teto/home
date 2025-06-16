local hurl = require('hurl')
hurl.setup({
    -- Show debugging info
    debug = true, -- writes to log in ~/.local/state/nvim/hurl.
	-- Specify your custom environment file name here
	-- by default
	-- env_file = {
	-- 	'hurl.env',
	-- },
    -- Show notification on run
    show_notification = false,
    -- find_env_files_in_folders(),
    -- find_env_files_in_folders = utils.find_env_files_in_folders,

    -- Show response in popup or split
    mode = 'split',
    -- Default formatter
    formatters = {
        json = { 'jq' }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
            'prettier', -- Make sure you have install prettier in your system, e.g: npm install -g prettier
            '--parser',
            'html',
        },
    },
	-- to avoid unauthorized access to file
	-- vim.fn.getcwd(),
	file_root = "/home/teto/nova";
})
