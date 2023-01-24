local M = {}
--
-- lua vim.diagnostic.setqflist({open = tru, severity = { min = vim.diagnostic.severity.WARN } })

        -- vim.diagnostic.config(conf)

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

return M
