-- inspired by https://github.com/yetone/avante.nvim/issues/1587

local rag_service = require('avante.rag_service')

local content_folder = '/home/teto/blog'

function Add()
    rag_service.add_resource(content_folder)
end

function Launch()
    rag_service.launch_rag_service(function()
        -- Callback when service is ready
        print('RAG service is running!')
    end)
end

local status = rag_service.indexing_status(content_folder)
print(vim.inspect(status)) -- View indexing progress
