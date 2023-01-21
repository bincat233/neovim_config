-- https://github.com/glepnir/lspsaga.nvim#packer
-- https://github.com/glepnir/lspsaga.nvim#configuration
--------------------------------------------------------------------------
-- 定义一个自己的调色板, 供后面调用
--require('lspsaga.lspkind')
local old_config = {
	diagnostic_header = { " ", " ", " ", " " },
	code_action_icon = "💡",
	--code_action_icon = " ",
	-- show outline
}
--------------------------------------------------------------
local lspsaga = require("lspsaga")
---------------------------------
lspsaga.setup({
	ui = {
		-- currently only round theme
		theme = "round",
		-- border type can be single,double,rounded,solid,shadow.
		border = "solid",
		expand = "",
		collapse = "",
		code_action = "💡",
		diagnostic = "🐞",
		colors = {
			--float window normal bakcground color
			--normal_bg = "#1d1536",
			normal_bg = vim.g.terminal_color_0,
			--title background color
			--title_bg = '#afd700',
			title_bg = vim.g.terminal_color_10,
			--red = '#e95678',
			red = vim.g.terminal_color_9,
			magenta = "#b33076",
			--orange = '#FF8700',
			orange = "#633819",
			--yellow = '#f7bb3b',
			yellow = vim.g.terminal_color_11,
			--green = '#afd700',
			green = vim.g.terminal_color_10,
			--cyan = '#36d0e0',
			cyan = vim.g.terminal_color_13,
			--blue = '#61afef',
			blue = vim.g.terminal_color_12,
			purple = "#CBA6F7",
			--white = "#d1d4cf",
			white = vim.g.terminal_color_15,
			--black = "#1c1c19",
			black = vim.g.terminal_color_0,

			----fg = "#bbc2cf",
			--red = "#cc3768",
			--green = "#4A672C",
			--teal = "#89b8c2",
			--yellow = "#e2a478",
			--orange = "#633819",
			--blue = "#1c3a74",
			--violet = "#6845ad",
			--cyan = "#327698",
		},
	},
	symbol_in_winbar = {
		enable = true,
		separator = "  ",
		show_file = true,
		hide_keyword = false,
		folder_level = 2,
	},
	lightbulb = {
    enable = true,
    enable_in_insert = true,
    sign = false,
    sign_priority = 40,
    virtual_text = true,
  },
})

vim.cmd('highlight CodeActionText guifg=' .. vim.g.terminal_color_15)

-- The keybindings are modified in ~/.config/nvim/lua/keybindings.lua
