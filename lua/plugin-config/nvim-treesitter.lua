local treesitter = safe_require("nvim-treesitter.configs")
local keys = require("keybindings")
if not treesitter or not keys then return end

treesitter.setup({
	-- 安装 language parser
	-- :TSInstallInfo 命令查看支持的语言
	ensure_installed = { "comment", "c", "cpp", "rust", "json", "html", "css", "vim", "lua", "javascript", "typescript", "tsx" },
	--ensure_installed = 'all',
	-- 启用代码高亮模块
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	-- 启用增量选择模块
	incremental_selection = {
		enable = true,
		-- NOTE: Set keybindings in ~/.config/nvim/lua/keybindings.lua
		keymaps = keys.ts_selection_keys,
	},
	-- 启用代码缩进模块 (=)
	indent = {
		enable = true,
	},
	-- 启用独立的彩虹括号模块
	-- Enable rainbow parentheses (need to install p00f/nvim-ts-rainbow)
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	}
})

-- 开启 Folding 模块
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.opt.foldlevel = 99

keys.ts_keys_setup()
