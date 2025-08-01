local M = {}




-- Override diagnostics in HLS
local haskell_diagnostic_severity = {
      -- No type signature at top level
      ["GHC-38417"] = vim.diagnostic.severity.HINT,
      -- Defined but not used
      ["GHC-40910"] = vim.diagnostic.severity.HINT,
      -- Defaulting
      ["GHC-18042"] = vim.diagnostic.severity.HINT,
      -- Warnings and deprecated
      ["GHC-63394"] = vim.diagnostic.severity.INFO,
      -- Deprecated
      ["GHC-68441"] = vim.diagnostic.severity.INFO,
     }



-- overrides vim.lsp.handlers["textDocument/publishDiagnostics"] 
-- should do so only when
function M.ignore_simwork_extended_warnings()
 -- Save the original handler
 local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
 vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
   if result and result.diagnostics then
	 for _, diag in ipairs(result.diagnostics) do
	   new_severity = haskell_diagnostic_severity[diag.code]
	   if new_severity ~= nil
	   then
		 diag.severity = new_severity
	   end
	 end
   end
   -- Pass to original handler
   orig_handler(err, result, ctx, config)
 end
end


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
    local conf = vim.diagnostic.config()
    conf.virtual_text = not enable
    if enable then
        conf.virtual_lines = { only_current_line = true }
    else
        conf.virtual_lines = false
    end

    -- vim.notify("setting diagnostic config to ", vim.inspect(conf))
    vim.diagnostic.config(conf)
end

--- severity being vim.diagnostic.severity.WARN
--- lua vim.diagnostic.hide(41,0)
-- lua vim.print(vim.api.nvim_get_namespaces())
-- lua vim.print(vim.diagnostic.get(0)) returned 0 as namespace
-- vim.diagnostic.severity.ERROR = 1
M.set_level = function(severity)
    -- Disable virtual_text since it's redundant due to lsp_lines.
    -- { min = }
    local opts = {
        signs = {
            severity = severity,
        },
    }
    local opts_global = {
        severity = { min = severity },
    }
    local diags = vim.diagnostic.get(0)
    local bufnr = vim.fn.bufnr('%')
    -- vim.diagnostic.config(opts_global)
    -- vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })

    -- needs diags to show
    -- signs are in a different namespace
    -- print("Setting bufnr", bufnr)
    -- • optional: (optional) boolean, if true, `nil` is valid

    print('setting severity ', severity, ' for buffer ', bufnr )
    -- lua vim.print(vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.HINT }})
    vim.diagnostic.show(31, bufnr, diags, { signs = { severity = severity } })
end

-- M.fake_diags = { {
--     _tags = {
--       unnecessary = true
--     },
--     bufnr = 6,
--     code = "SC2034",
--     col = 0,
--     end_col = 15,
--     end_lnum = 3,
--     lnum = 3,
--     message = "reference_flake appears unused. Verify use (or export if used externally).",
--     namespace = 38,
--     severity = 2,
--     source = "shellcheck",
--     user_data = {
--       lsp = {
--         code = "SC2034",
--         codeDescription = {
--           href = "https://www.shellcheck.net/wiki/SC2034"
--         },
--         data = {
--           id = "shellcheck|2034|3:0-3:15"
--         }
--       }
--     }
--   }, {
--     _tags = {
--       unnecessary = true
--     },
--     bufnr = 6,
--     code = "SC2034",
--     col = 0,
--     end_col = 6,
--     end_lnum = 4,
--     lnum = 4,
--     message = "target appears unused. Verify use (or export if used externally).",
--     namespace = 38,
--     severity = 2,
--     source = "shellcheck",
--     user_data = {
--       lsp = {
--         code = "SC2034",
--         codeDescription = {
--           href = "https://www.shellcheck.net/wiki/SC2034"
--         },
--         data = {
--           id = "shellcheck|2034|4:0-4:6"
--         }
--       }
--     }
--   }
--  }

-- update_in_insert:
return M
