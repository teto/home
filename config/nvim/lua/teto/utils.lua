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

function M.print_large_toto()
    -- Kitty font size protocol using OSC 50
    -- Set font size to 3x (300%)
    io.write('\027]50;size=300\027\\')
    print('toto')
    -- Reset font size to normal (100%)
    io.write('\027]50;size=100\027\\')
    io.flush()
    -- local k = vim.keycode
    -- vim.g.mapleader = k'<bs>'
end

-- use altfont
function M.show_line_large(line_nr)
    local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })

    local width = math.min(#line + 4, vim.o.columns - 10)
    local height = 3

    vim.api.nvim_open_win(buf, false, {
        relative = 'cursor',
        width = width,
        height = height,
        row = 1,
        col = 0,
        style = 'minimal',
        border = 'rounded',
    })
end
return M
