local bufferline = safe_require("bufferline")
local keybindings = safe_require("keybindings")
if not bufferline or not keybindings then return end

-- bufferline 配置
-- https://github.com/akinsho/bufferline.nvim#configuration
bufferline.setup({
	options = {
		-- 关闭 Tab 的命令，这里使用 moll/vim-bbye 的 :Bdelete 命令
		close_command = "Bdelete! %d",
		right_mouse_command = "Bdelete! %d",
		-- 侧边栏配置
		-- 左侧让出 nvim-tree 的位置，显示文字 File Explorer
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
		-- Hover event
		hover = {
			enabled = true,
			delay = 100,
			reveal = {'close'}
		},
		indicator = {
			icon = "▎",
			style = "icon", -- "icon" | "underline" | "none"
		},
		-- 使用 nvim 内置 LSP  后续课程会配置
		diagnostics = "nvim_lsp",
		-- 可选，显示 LSP 报错图标
		---@diagnostic disable-next-line: unused-local
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " " or (e == "warning" and " " or "")
				s = s .. n .. sym
			end
			return s
		end,
	},
})

-- Set keybindings conditional on bufferline being loaded
keybindings.bufferline_keys_setup()
