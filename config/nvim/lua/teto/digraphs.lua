-- This is better-digraphs.nvim with telescope.nvim replaced with vim.ui.select
--   (original is at: https://github.com/protex/better-digraphs.nvim)
--
-- Add digraphs using vim.g.select_digraph_additions:
-- vim.g.select_digraph_additions = {
--   {
--     digraph = "OK",
--     symbol = "*",
--     name = "NEW STAR"
--   },
--   {
--     digraph = "zz",
--     symbol = "Z",
--     name = "CAPITAL Z"
--   }
-- }

local M = {}

M.config = nil

local default_config = {
	maps = {
		i = "<C-k><C-k>",
		n = "r<C-k><C-k>",
		v = "r<C-k><C-k>",
	}
}

local function get_cursor_column()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col
end

local function restore_input(cursor_column)
	if vim.fn.mode() ~= "i" then
		if cursor_column == #vim.api.nvim_get_current_line() then
			vim.api.nvim_feedkeys("a", "", false)
		else
			vim.api.nvim_feedkeys("i", "", false)
		end
	end
end

local function match_digraph_table_header(line)
	return string.match(line, "official name")
end

local function is_empty_string(line)
	return line == ""
end

local function match_digraph_table_footer(line)
	return string.match(line, "vim:tw=78:ts=8:noet:ft=help:norl:")
end

local function get_digraph_from_doc()
	local digraph_doc = vim.fn.expand("$VIMRUNTIME/doc/digraph.txt")
	local ok, f_lines = pcall(io.lines, digraph_doc)
	if ok then
		local lines = {}
		local line_number = 1
		local table_found = false
		for line in f_lines do
			if string.match(line, "digraph%-table%-mbyte") then
				table_found = true
				line_number = 1
			elseif
				table_found
				and not match_digraph_table_header(line)
				and not is_empty_string(line)
				and not match_digraph_table_footer(line)
			then
				lines[line_number] = line
				line_number = line_number + 1
			end
		end
		return lines
	end
	return {}
end

-- Convert file into digraph:
local function get_digraph_from_line(line)
	local columns = vim.fn.split(line, "\t")
	return { columns[5], columns[2], columns[1] }
end

-- Strip digraphs that didn't parse correctly:
local function is_valid_digraph(item)
	return #item == 3 and item[1] ~= nil and item[2] ~= nil and item[3] ~= nil
end

local function generate_digraphs()
	local digraph_list = get_digraph_from_doc()
	digraph_list = vim.tbl_map(get_digraph_from_line, digraph_list)
	digraph_list = vim.tbl_filter(is_valid_digraph, digraph_list)

	-- Handle any custom digraphs:
	if vim.g.select_digraph_additions then
		for _, digraph_addition in pairs(vim.g.select_digraph_additions) do
			if string.len(digraph_addition.digraph) ~= 2 then
				error(
					"Digraph "
						.. digraph_addition.digraph
						.. " should have 2 characters, found "
						.. string.len(digraph_addition.digraph)
				)
			end
			if string.len(digraph_addition.symbol) ~= 1 then
				error(
					"Digraph symbol "
						.. digraph_addition.symbol
						.. " should have 1 characters, found "
						.. string.len(digraph_addition.symbol)
				)
			end
			table.insert(digraph_list, {
				digraph_addition.name,
				digraph_addition.digraph,
				digraph_addition.symbol,
			})
			vim.fn.digraph_set(digraph_addition.digraph, digraph_addition.symbol)
		end
	end
	return digraph_list
end

local digraphs = nil

function M.select(mode)
	mode = mode or "i"

	if digraphs == nil then
		digraphs = generate_digraphs()
	end
	local cursor_column = get_cursor_column()

	vim.ui.select(digraphs, {
		prompt = "Digraph: ",
		format_item = function(item)
			return item[1] .. " (" .. item[2] .. "): " .. item[3]
		end,
	}, vim.schedule_wrap(function(choice)
		if choice == nil then
			if mode == "i" then -- Restore input
				restore_input(cursor_column)
			elseif mode == "gvr" then -- Restore visual selection
				vim.api.nvim_feedkeys("gv", "", false)
			end
			return
		end

		if mode == "i" then
			restore_input(cursor_column)
			vim.api.nvim_feedkeys("" .. choice[2], "", false)
		elseif mode == "r" then
			vim.api.nvim_feedkeys("r" .. choice[2], "", false)
		elseif mode == "gvr" then
			vim.api.nvim_feedkeys((vim.fn.mode():match("^[vV]") and "" or "gv") .. "r" .. choice[2], "", false)
		end
	end))
end

function M.setup(opts)
	if M.config == nil then
		M.config = vim.tbl_deep_extend("keep", opts or {}, default_config)
	end

	vim.keymap.set("i", "<Plug>(select-digraphs-i)", "<cmd>lua require('teto.digraphs').select('i')<CR>")
	vim.keymap.set("n", "<Plug>(select-digraphs-n)", "<cmd>lua require('teto.digraphs').select('r')<CR>")
	vim.keymap.set("v", "<Plug>(select-digraphs-v)", "<cmd>lua require('teto.digraphs').select('gvr')<CR>")

	for mode, map in pairs(M.config.maps) do
		-- Set a map to nil or "" to disable:
		if type(map) == "string" and map ~= "" then
			vim.keymap.set(mode, map, "<Plug>(select-digraphs-" .. mode .. ")")
		end
	end
end

return M
