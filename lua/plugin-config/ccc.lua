-- Enable true color
vim.opt.termguicolors = true
local ccc = require("ccc")
local mapping = ccc.mapping
ccc.setup({
	highlighter = { auto_enable = true},
})
