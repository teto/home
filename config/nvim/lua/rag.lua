-- inspired by https://github.com/yetone/avante.nvim/issues/1587

-- lua require('avante.rag_service').add_resource( 'file:///home/teto/home')
local rag_service = require('avante.rag_service')

local content_folder = 'file:///home/teto/blog'

function Add()
    rag_service.add_resource(content_folder)
end

-- presumably run manually
function Launch()
    rag_service.launch_rag_service(function()
        -- Callback when service is ready
        print('RAG service is running!')
    end)
end

Add()
local status = rag_service.indexing_status(content_folder)
print(vim.inspect(status)) -- View indexing progress
