-- Copied from
-- https://github.com/ibhagwan/fzf-lua/discussions/1483
local cmd = ''
local buffers = {}
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname ~= '' then
            bufname = vim.fn.fnamemodify(bufname, ':~:.')
            if
                string.find(vim.fs.basename(bufname), 'NvimTree_') ~= 1 -- filter out nvim tree buffer
                and bufname ~= vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.') -- filter out current buffer
            then
                local info = vim.fn.getbufinfo(bufnr)
                table.insert(buffers, { name = bufname, info = info[1] or info })
            end
        end
    end
end

table.sort(buffers, function(a, b)
    return a.info.lastused > b.info.lastused
end)

for _, buffer in ipairs(buffers) do
    cmd = cmd .. 'echo "' .. buffer.name .. '" && '
end

cmd = cmd .. 'fd --color=never --type f --hidden --follow --exclude .git'

for _, buffer in ipairs(buffers) do
    cmd = cmd .. ' --exclude "' .. buffer.name .. '"'
end

require('fzf-lua').files({ cmd = cmd, fzf_opts = { ['--tiebreak'] = 'index' } })
