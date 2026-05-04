return {
    {
        name = 'Add breakpoint',
        items = require('dap').toggle_breakpoint(),
    },
    {
        name = 'Continue',
        items = require('dap').continue(),
    },
    {
        name = 'repl',
        items = require('dap').repl.open(),
    },
}
