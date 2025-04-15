local M = {}

function M.apply_function_to_selection(func)
    -- Get the current buffer
    local bufnr = vim.api.nvim_get_current_buf()

    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Adjust for Lua indexing (1-based in Vim, 0-based in Lua)
    local start_line = start_pos[2] - 1
    local start_col = start_pos[3] - 1
    local end_line = end_pos[2] - 1
    local end_col = end_pos[3]

    -- Get the selected lines
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

    -- Handle multiline selection (only first and last lines need column adjustments)
    if #lines > 0 then
        lines[1] = string.sub(lines[1], start_col + 1)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    -- Join lines, apply the function, and split back into lines
    local text = table.concat(lines, '\n')
    local processed_text = func(text)
    local processed_lines = vim.split(processed_text, '\n', true)

    -- Replace the selected lines with the processed lines
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line + 1, false, processed_lines)
end

return M
