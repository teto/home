return {
    {
        name = 'list remote models',
        cmd = function()
            print(vim.inspect(require('avante.providers').openai:list_models()))
        end,
        -- items =
    },
    {
        name = 'select new provider',
        cmd = 'AvanteSwitchProvider',
    },
    {
        name = 'Talk to model',
        cmd = 'AvanteChat',
    },
}
