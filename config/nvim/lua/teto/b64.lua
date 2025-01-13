local utils = require('teto.utils')
-- lua print(vim.base64.encode([[{"resources": {}, 'projectId': "toto"}']]))jjj
--
local function b64encode(content)
    return vim.base64.encode(content)
end

-- Example function: Base64 encode
local function base64_encode(input)
    return vim.fn.system('base64', input):gsub('\n$', '') -- Remove trailing newline
end
