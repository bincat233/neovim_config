local nvim_tree=safe_require('nvim-tree')
local keybindings=safe_require('keybindings')
if not nvim_tree or not keybindings then return end

nvim_tree.setup({
	open_on_setup = true,
	--disable_netrw = true, -- 禁止内置netrw
	-- git = { -- 不显示git状态
	-- 		enable = true,
	-- 		ignore = true,
	-- },
	update_cwd = true, -- project plugin 需要这样设置
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	-- 隐藏 .文件 和 node_modules 文件夹
	filters = {
		--dotfiles = true,
		custom = { 'node_modules' },
	},
	view = {
		--width = 20, -- 宽度
		adaptive_size = true, -- 自适应宽度
		side = 'left', -- Also 'right'
		hide_root_folder = false, -- 隐藏根目录
		-- 自定义列表中快捷键
		mappings = {
			custom_only = false,
			list = keybindings.nvim_tree,
		},
		number = false, -- 不显示行数
		relativenumber = false,
		signcolumn = 'yes', -- 显示图标
	},
	actions = {
		open_file = {
			resize_window = true, -- 首次打开大小适配
			quit_on_open = true, -- 打开文件时关闭
		},
	},
	system_open = {
		cmd = 'xdg-open', -- 'wsl-open' if windows (need install wsl-open)
	},
})

-- 自动关闭
vim.cmd([[
	autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])

-- Setup global keybindings
keybindings.nvim_tree_keys_setup()
