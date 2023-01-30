local M = {}

-- see https://git.sr.ht/~whynothugo/lsp_lines.nvim
-- for additionnal config
M.default_config = {
	-- disabled because too big in haskell
	virtual_lines = { only_current_line = true },
	virtual_text = false,
	-- {
	-- severity = { min = vim.diagnostic.severity.WARN }
	-- },
	signs = true,
	severity_sort = true,
    -- update_in_insert = false,
}

--
-- lua vim.diagnostic.setqflist({open = tru, severity = { min = vim.diagnostic.severity.WARN } })
-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.cmd [[autocmd CursorHold <buffer> lua showLineDiagnostic()]]
-- vim.cmd [[autocmd CursorMoved <buffer> lua showLineDiagnostic()]]
-- function lsp_show_all_diagnostics()
--	local all_diagnostics = vim.lsp.diagnostic.get_all()
--	vim.lsp.util.set_qflist(all_diagnostics)
-- end

        -- vim.diagnostic.config(conf)
-- -- pb c'est qu'il l'autofocus
-- autocmd User LspDiagnosticsChanged lua vim.lsp.diagnostic.set_loclist( { open = false,  open_loclist = false})

-- command! LspStopAllClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())
--
-- luacheck: globals diagnostics_active
diagnostics_active = true

-- code to toggle diagnostic display
M.toggle_diagnostic_display = function()
-- local diagnostics_active = true
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end


-- toggle between virttext / lsp_lines / nothing
M.set_lsp_lines = function(enable)
-- local diagnostics_active = true
    local conf = M.default_config
    conf.virtual_text = not enable
    if enable then
      conf.virtual_lines = { only_current_line = true }
    else
      conf.virtual_lines = false
    end

   vim.diagnostic.config(conf)
end

--- severity being vim.diagnostic.severity.WARN
M.set_level = function (severity)
   -- Disable virtual_text since it's redundant due to lsp_lines.
   vim.diagnostic.config({
    severity = { min = severity }
   })
 end

return M
