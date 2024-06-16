local theme = require('last-color').recall() or 'sonokai'
-- print("Setting colorscheme ", theme )
vim.cmd(('colorscheme %s'):format(theme))
