-- https://github.com/glepnir/lspsaga.nvim#packer
-- https://github.com/glepnir/lspsaga.nvim#configuration
--------------------------------------------------------------------------
-- 定义一个自己的调色板, 供后面调用
--require('lspsaga.lspkind')
local custom_colors= {
	--fg = "#262a3f",
	----fg = "#bbc2cf",
	--red = "#cc3768",
	--green = "#4A672C",
	--teal = "#89b8c2",
	--yellow = "#e2a478",
	--orange = "#633819",
	--blue = "#1c3a74",
	--violet = "#6845ad",
	--cyan = "#327698",

	fg = "#262a3f",
	red = vim.g.terminal_color_9,
	green = vim.g.terminal_color_10,
	teal = "#89b8c2",
	yellow = vim.g.terminal_color_11,
	orange = "#633819",
	blue = vim.g.terminal_color_12,
	violet = vim.g.terminal_color_13,
	cyan = vim.g.terminal_color_13,

}
--------------------------------------------------------------
local lspsaga = require 'lspsaga'
lspsaga.init_lsp_saga({ -- defaults ...
-- Options with default value
-- "single" | "double" | "rounded" | "bold" | "plus"
border_style = "single",
--the range of 0 for fully opaque window (disabled) to 100 for fully
--transparent background. Values between 0-30 are typically most useful.
saga_winblend = 0,
-- when cursor in saga window you config these to move
move_in_saga = { prev = '<C-p>',next = '<C-n>'},
-- Error, Warn, Info, Hint
-- use emoji like
-- { "🙀", "😿", "😾", "😺" }
-- or
-- { "😡", "😥", "😤", "😐" }
-- and diagnostic_header can be a function type
-- must return a string and when diagnostic_header
-- is function type it will have a param `entry`
-- entry is a table type has these filed
-- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
--diagnostic_header = { " ", " ", " ", "ﴞ " },
diagnostic_header = { " ", " ", " ", " ", },
-- preview lines above of lsp_finder
preview_lines_above = 0,
-- preview lines of lsp_finder and definition preview
max_preview_lines = 10,
-- use emoji lightbulb in default
code_action_icon = "💡",
--code_action_icon = " ",
-- if true can press number to execute the codeaction in codeaction window
code_action_num_shortcut = true,
-- same as nvim-lightbulb but async
code_action_lightbulb = {
	enable = true,
	enable_in_insert = true,
	cache_code_action = true,
	sign = false,
	update_time = 150,
	sign_priority = 20,
	virtual_text = true,
},
-- finder icons
finder_icons = {
	def = '  ',
	ref = '諭 ',
	link = '  ',
},
-- finder do lsp request timeout
-- if your project is big enough or your server very slow
-- you may need to increase this value
finder_request_timeout = 1500,
finder_action_keys = {
	open = {'o', '<CR>'},
	vsplit = 's',
	split = 'i',
	tabe = 't',
	quit = {'q', '<ESC>'},
	scroll_down = "<C-f>",
	scroll_up = "<C-b>",
},
code_action_keys = {
	quit = 'q',
	exec = '<CR>',
},
definition_action_keys = {
	edit = '<C-c>o',
	vsplit = '<C-c>v',
	split = '<C-c>i',
	tabe = '<C-c>t',
	quit = 'q',
},
rename_action_quit = '<C-c>',
rename_in_select = true,
-- show symbols in winbar must nightly
-- in_custom mean use lspsaga api to get symbols
-- and set it to your custom winbar or some winbar plugins.
-- if in_cusomt = true you must set in_enable to false
symbol_in_winbar = {
	in_custom = true,
	--enable = true,
	separator = '  ',
	show_file = true,
	-- define how to customize filename, eg: %:., %
	-- if not set, use default value `%:t`
	-- more information see `vim.fn.expand` or `expand`
	-- ## only valid after set `show_file = true`
	file_formatter = "",
	click_support = function(node, clicks, button, modifiers)
		-- To see all avaiable details: vim.pretty_print(node)
		local st = node.range.start
		local en = node.range["end"]
		if button == "l" then
			if clicks == 2 then
				-- middle click to visual select node
				vim.fn.cursor(st.line + 1, st.character + 1)
				vim.cmd "normal V"
				vim.fn.cursor(en.line + 1, en.character + 1)
			else
				-- jump to node's starting line+char
				vim.fn.cursor(st.line + 1, st.character + 1)
			end
		elseif button == "r" then
			print "do nothing"
		elseif button == "m" then
			print "do nothing"
		end
	end,
},
-- show outline
show_outline = {
	win_position = 'right',
	--set special filetype win that outline window split.like NvimTree neotree
	-- defx, db_ui
	win_with = '',
	win_width = 30,
	auto_enter = true,
	auto_preview = true,
	virt_text = '┃',
	jump_key = 'o',
	-- auto refresh when change buffer
	auto_refresh = true,
},
-- custom lsp kind
-- usage { Field = 'color code'} or {Field = {your icon, your color code}}
-- 为每一种图标设置调色板
custom_kind = {
	File= { ' ', custom_colors.fg },
	Module= { ' ', custom_colors.blue },
	Namespace= { ' ', custom_colors.orange },
	Package= { ' ', custom_colors.violet },
	Class= { ' ', custom_colors.violet },
	Method= { ' ', custom_colors.violet },
	Property= { ' ', custom_colors.cyan },
	Field= { ' ', custom_colors.teal },
	Constructor= { ' ', custom_colors.blue },
	Enum= { '了', custom_colors.green },
	Interface= { ' ', custom_colors.orange },
	Function= { ' ', custom_colors.violet },
	Variable= { ' ', custom_colors.blue },
	Constant= { ' ', custom_colors.cyan },
	String= { ' ', custom_colors.green },
	Number= { ' ', custom_colors.green },
	Boolean= { ' ', custom_colors.orange },
	Array= { ' ', custom_colors.blue },
	Object= { ' ', custom_colors.orange },
	Key= { ' ', custom_colors.red },
	Null= { ' ', custom_colors.red },
	EnumMember= { ' ', custom_colors.green },
	Struct= { ' ', custom_colors.violet },
	Event= { ' ', custom_colors.violet },
	Operator= { ' ', custom_colors.green },
	TypeParameter= { ' ', custom_colors.green },
	-- ccls
	TypeAlias= { ' ', custom_colors.green },
	Parameter= { ' ', custom_colors.blue },
	StaticMethod= { 'ﴂ ', custom_colors.orange },
	Macro= { ' ', custom_colors.red },
},
-- if you don't use nvim-lspconfig you must pass your server name and
-- the related filetypes into this table
-- like server_filetype_map = { metals = { "sbt", "scala" } }
server_filetype_map = {},
})

--------------------------------------------------------------------------------------------------------------------------
-- Winbar config: Copy from: https://alpha2phi.medium.com/neovim-101-status-line-winbar-and-buffer-line-404600bcd982
-- Example:
local function get_file_name(include_path)
	local file_name = require("lspsaga.symbolwinbar").get_file_name({})
	if vim.fn.bufname "%" == "" then
		return ""
	end
	if include_path == false then
		return file_name
	end
	-- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
	local sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
	local path_list = vim.split(string.gsub(vim.fn.expand "%:~:.:h", "%%", ""), sep)
	local file_path = ""
	for _, cur in ipairs(path_list) do
		file_path = (cur == "." or cur == "~") and "" or file_path .. cur .. " " .. "%#LspSagaWinbarSep#>%*" .. " %*"
	end
	return file_path .. file_name
end

local function config_winbar_or_statusline()
	local exclude = {
		["terminal"] = true,
		["toggleterm"] = true,
		["prompt"] = true,
		["NvimTree"] = true,
		["help"] = true,
	} -- Ignore float windows and exclude filetype
	if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
		vim.wo.winbar = ""
	else
		local ok, sagawinbar = pcall(require, "lspsaga.symbolwinbar")
		local sym
		if ok then
			sym = sagawinbar.get_symbol_node()
		end
		local win_val = ""
		win_val = get_file_name(true) -- set to true to include path
		if sym ~= nil then
			win_val = win_val .. sym
		end
		vim.wo.winbar = win_val

		-- if work in statusline
		-- vim.wo.stl = win_val
	end
end

local events = { "BufEnter", "BufWinEnter", "CursorMoved" }

vim.api.nvim_create_autocmd(events, {
	pattern = "*",
	callback = function()
		config_winbar_or_statusline()
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LspsagaUpdateSymbol",
	callback = function()
		config_winbar_or_statusline()
	end,
})


-- The keybindings are modified in ~/.config/nvim/lua/keybindings.lua
